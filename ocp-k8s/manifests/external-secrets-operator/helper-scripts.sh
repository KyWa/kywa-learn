#!/usr/bin/env bash

# Import/Source this script into your current shell and then you can use these functions

# Get the TLS Key data into a single line to input into a Secrets management vault
# Run like so: trim-tls-key /path/to/tls.key
trim-tls-key(){
  cat $1 | tr '\n' ' '

  # The TLS key output should return like so:
  ## Before
  # -----BEGIN PRIVATE KEY-----
  # MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC1zomvXp1Z+z3H
  # dswwxdfuSDWLepqPkjbBU//oDQv8G272+QHtLUq5Rxf3Z4pd5odFfn7ug4JhCnrz
  # ...
  ## After
  # -----BEGIN PRIVATE KEY----- MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC1zomvXp1Z+z3H dswwxdfuSDWLepqPkjbBU//oDQv8G272+QHtLUq5Rxf3Z4pd5odFfn7ug4JhCnrz...
}

# For batching out converting your TLS certificates you can do something like the following
# This function uses the 03a-certificate-secret.yaml as an example
# Run like so: convert-tls-cert /path/to/tls.crt
convert-tls-cert(){
  cert=$(cat $1 | sed -e 's/^/          /g')
  printf '%s\n' "$cert" | sed -i -e '/CERTDATA$/r /dev/stdin' -e '//d' 03a-certificate-secret.yaml

  # The above will do the following in order:
  # 1. Get your TLS certificate and tab it over to be put into an ExternalSecret
  # 2. Replace the "CERTDATA" string with the tabbed over TLS certificate
}
