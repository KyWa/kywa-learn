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
}
