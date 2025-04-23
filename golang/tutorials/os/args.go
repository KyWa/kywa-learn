package main

import (
    "fmt"
    "os"
    "log"
)

func main() {
    args := os.Args[1:]

    if len(args) != 1 {
        log.Fatal("Invalid args. Requires only one")
    }

    argTest(args[0])
}

func argTest(arg1 string) {
    data, err := os.ReadFile(arg1)
    if err != nil {
        log.Fatal(err)
    }

    fmt.Printf("%s",data)
}
