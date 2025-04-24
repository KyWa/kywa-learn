package main

import "fmt"

func main(){
    // declare the map with data types
    myMap := map[string]int{"kyle":40,"tina":40,"mckenzie":14}

    fmt.Println(myMap)

    // Get the value of Kyle from the map
    fmt.Println(myMap["kyle"])

    // Check for values
    age, ok := myMap["snotling"]

    if ok{
        fmt.Printf("someone is %v years old", age)
    }else {
        fmt.Println("Invalid name")
    }

    // built-in delete function to remove an entry
    fmt.Println(myMap)
    delete(myMap, "kyle")
    fmt.Println(myMap)
}
