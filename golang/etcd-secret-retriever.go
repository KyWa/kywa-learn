package main

import (
	"bytes"
	"context"
	"crypto/aes"
	"crypto/cipher"
	"crypto/tls"
	"encoding/base64"
	"flag"
	"fmt"
	"os"
	"strings"
	"time"

	"go.etcd.io/etcd/clientv3"
	"go.etcd.io/etcd/pkg/transport"
	jsonserializer "k8s.io/apimachinery/pkg/runtime/serializer/json"
	"k8s.io/apiserver/pkg/storage/value"
	aestransformer "k8s.io/apiserver/pkg/storage/value/encrypt/aes"
	"k8s.io/kubectl/pkg/scheme"
)

const (
	AESCBC_PREFIX = "k8s:enc:aescbc:v1:"
)

func main() {

	var endpoint, keyFile, certFile, caFile, encryptionSecret, encryptionkey, etcdKey string
	flag.StringVar(&endpoint, "endpoints", getenv("ETCDCTL_ENDPOINTS"), "Etcd endpoints.")
	flag.StringVar(&keyFile, "key", getenv("ETCDCTL_KEY"), "TLS client key.")
	flag.StringVar(&certFile, "cert", getenv("ETCDCTL_CERT"), "TLS client certificate.")
	flag.StringVar(&caFile, "cacert", getenv("ETCDCTL_CACERT"), "Server TLS CA certificate.")
	flag.StringVar(&encryptionkey, "encryption-key", getenv("ENCRYPTION_KEY"), "Encryption Key.")
	flag.StringVar(&encryptionSecret, "encryption-secret", getenv("ENCRYPTION_SECRET"), "Encryption Secret.")

	flag.Parse()

	if flag.NArg() == 0 {
		fmt.Fprint(os.Stderr, "ERROR: you need to specify an etcd key\n")
		os.Exit(1)
	}

	if len(encryptionkey) == 0 || len(encryptionSecret) == 0 {
		fmt.Fprint(os.Stderr, "ERROR: you need to specify an encryption key and secret\n")
		os.Exit(1)
	}

	etcdKey = flag.Arg(0)

	var tlsConfig *tls.Config

	if len(certFile) != 0 || len(keyFile) != 0 || len(caFile) != 0 {

		tlsInfo := transport.TLSInfo{
			CertFile:      certFile,
			KeyFile:       keyFile,
			TrustedCAFile: caFile,
		}
		var err error
		tlsConfig, err = tlsInfo.ClientConfig()
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR: unable to create client config: %v\n", err)
			os.Exit(1)
		}
	}

	config := clientv3.Config{
		Endpoints:   strings.Split(endpoint, ","),
		TLS:         tlsConfig,
		DialTimeout: 5 * time.Second,
	}
	client, err := clientv3.New(config)
	if err != nil {
		fmt.Printf("ERROR: unable to connect to etcd: %v\n", err)
		os.Exit(1)
	}
	defer client.Close()

	response, err := clientv3.NewKV(client).Get(context.Background(), etcdKey)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to Retrieve Key from ETCD: %v", err)
		os.Exit(1)
	}

	if !bytes.HasPrefix(response.Kvs[0].Value, []byte(AESCBC_PREFIX)) {
		fmt.Fprintf(os.Stderr, "Expected encrypted value to be prefixed with %s, but got %s", AESCBC_PREFIX, response.Kvs[0].Value)
		return
	}

	block, err := newAESCipher(encryptionSecret)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to create cipher from key: %v", err)
		os.Exit(1)

	}

	cbcTransformer := aestransformer.NewCBCTransformer(block)

	ctx := value.DefaultContext(etcdKey)

	enveloperPrefix := fmt.Sprintf("%s%s:", AESCBC_PREFIX, encryptionkey)

	sealedData := response.Kvs[0].Value[len(enveloperPrefix):]

	clearText, _, err := cbcTransformer.TransformFromStorage(sealedData, ctx)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to decrypt secret: %v", err)
		os.Exit(1)
	}

	decoder := scheme.Codecs.UniversalDeserializer()
	encoder := jsonserializer.NewYAMLSerializer(jsonserializer.DefaultMetaFactory, scheme.Scheme, scheme.Scheme)

	obj, _, err := decoder.Decode(clearText, nil, nil)

	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to Decode: %v", err)
		os.Exit(1)
	}

	err = encoder.Encode(obj, os.Stdout)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to decode to standard out: %v", err)
		os.Exit(1)

	}

}

func newAESCipher(key string) (cipher.Block, error) {
	k, err := base64.StdEncoding.DecodeString(key)
	if err != nil {
		return nil, fmt.Errorf("failed to decode config secret: %v", err)
	}

	block, err := aes.NewCipher(k)
	if err != nil {
		return nil, fmt.Errorf("failed to create AES cipher: %v", err)
	}

	return block, nil
}

func getenv(key string) string {

	if value, exists := os.LookupEnv(key); exists {
		return value
	}

	return ""
}
