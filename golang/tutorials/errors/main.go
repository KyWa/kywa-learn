package main

import (
    "fmt"
    "log"
    "errors"
    "os"
)

func main() {
    args := os.Args[1:]

    if len(args) != 1 {
        log.Fatal("Invalid args. Requires only one")
    }

    fmt.Println("just before the call")

    snickers, err := tester(args[0])

    if err != nil {
        fmt.Printf(err.Error())
    }

    if args[0] == "panic" {
        panic(err)
    }

    fmt.Printf("Made it out alive with %v", snickers)
}

func tester(var1 string) (string, error){
    fmt.Println("Beginning of function")
    var err error

    if var1 == "fail" {
        err = errors.New("Custom error message")
    }

    fmt.Println("Just before return of function")
    return var1, err
}
