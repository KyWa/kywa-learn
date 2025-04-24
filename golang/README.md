# Golang Environment in a Container

[Image Repository on Quay](https://quay.io/repository/kywa/goenv)

This is initially being used as a test for the sake of keeping the host environment clean and running all jobs and development inside a container.

## Usage

Run from your working directory where your `go` code lives:

```
podman run -it -v ${PWD}:/opt/app-root/src quay.io/kywa/go-env:latest /bin/bash
```

* [Go](https://golang.org) Version: 1.23
