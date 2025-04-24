package main

import (
    "fmt"
    "errors"
)

func main(){
    var1, var2 := 100, 0
    result, remainder, err := intDivision(var1, var2)
    if err != nil{
        fmt.Printf(err.Error())
    }
    fmt.Printf("Behold, the values of %v and %v", result, remainder)
}

func intDivision(numerator int, denominator int) (int, int, error){
    var err error

    // error handling
    if denominator == 0 {
        err = errors.New("Cannot divide by 0 dude")
        return 0, 0, err
    }

    // creates a variable based on the inputs from when the function was called and divides them
    division := numerator/denominator
    // creates a variable based on the inputs from when the function was called and gets the remainder from their division
    remainder := numerator%denominator

    return division, remainder, err
}
