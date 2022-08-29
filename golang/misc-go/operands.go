package main

import "fmt"

func main() {
    // checking boolean statements
    fmt.Println(true && true)
    fmt.Println(true && false)
    fmt.Println(true || true)
    fmt.Println(true || false)
    fmt.Println(!true)

    // For loop basic example
    for i := 1; i <=10; i++ {
        // checking for odd/even with modulus
        if i % 2 == 0 {
            fmt.Println(i, " is even")
        } else {
            fmt.Println(i, " is odd")
        }
    }

    // for loop
    for i := 1; i <=10; i++ {
        // switch (aka BASH case statement)
        switch i {
        case 0: fmt.Println("Zero")
        case 1: fmt.Println(one(5))
        case 2: fmt.Println("Two")
        case 3: fmt.Println("Three")
        case 4: fmt.Println("Four")
        case 5: fmt.Println("Five")
        default: fmt.Println("Aint nobody know")
        }
    }
}


func one(x int) int {
    z := 5
    z = x * 5
    return z
}
