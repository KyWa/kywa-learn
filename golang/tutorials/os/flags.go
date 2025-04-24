package main

import (
    "flag"
    "fmt"
)

func main() {
    // flag is a more elaborate os.Args in that you give it a type, name and description to be used as well as a built in "usage" return with -h
    strArg := flag.String("string", "foo", "a string")
    intArg := flag.Int("int", 42, "an int")
    boolArg := flag.Bool("boolean", false, "a bool")

    // This section is where a const is used to essentially allow a "shorthand" for a flag
    var strVar string

	const (
		coreString = "something"
		usage = "what type of fun"
	)

	flag.StringVar(&strVar, "core", coreString, usage)
	flag.StringVar(&strVar, "c", coreString, usage+" (shorthand of 'core')")

    flag.Parse()

    fmt.Println("String:", *strArg)
    fmt.Println("Integer:", *intArg)
    fmt.Println("Boolean:", *boolArg)
    fmt.Println("StringVar:", strVar)

    // flag.NArg is equal to the number of args after flags have been processed
    if flag.NArg() > 0 {
        fmt.Println("Remainder Args:", flag.Args())
    }
}
