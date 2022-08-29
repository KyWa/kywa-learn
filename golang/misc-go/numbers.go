package main

import "fmt"

func main() {
    var input float64

    // these 2 lines are the equivelant of a BASH style:
    // echo "Enter a number: ";read input
    fmt.Print("Enter a number: ")
    fmt.Scanf("%f", &input)

    output := input * 2
    fmt.Println(output)

    for i := 1; i <= 100; i++ {
        if i % 3 == 0 {
            fmt.Println(i, " is divisible by 3")
        } else {
            fmt.Println(i, " isn't divisible by 3")
        }
    }

    for i := 1; i <= 100; i++ {
        if i % 3 == 0 && i % 5 == 0 {
            fmt.Println("FizzBuzz")
        } else if i % 3 == 0 {
            fmt.Println("Fizz")
        } else if i % 5 == 0 {
            fmt.Println("Buzz")
        }
    }
}
