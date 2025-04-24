package main

import "fmt"

func main(){
    // declare the map with data types
    myMap := map[string]int{"kyle":40,"tina":40,"mckenzie":14}

    // basic for loop
    for name, age := range myMap{
        fmt.Printf("Name: %v, Age %v \n", name, age)
    }

    // initialization, condition, post
    for b := 0; b<= 10; b++ {
        fmt.Println(b)
    }

    // "while" loop
    i := 0
    for i <= 10 {
        fmt.Println(i)
        i = i + 1
    }

    // "while" loop alternative
    z := 0
    for {
        if z >= 10 {
            break
        }
        fmt.Println(z)
        z = z + 1
    }
}
