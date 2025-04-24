package main

import "fmt"

func main(){
    // Array
    intarray := [3]int{1,2,3}

    fmt.Println(intarray)
    fmt.Println(intarray[2])

    // Slice
    intslice := []int{1,2,3}
    
    fmt.Println(intslice)

    // Append to Slice
    intslice = append(intslice, 7)

    fmt.Println(intslice)
    fmt.Println(intslice[1])

    // Append to Slice with another Slice
    intslice2 := []int{99,14,6}
    intslice = append(intslice, intslice2...)

    fmt.Println(intslice)

    // Create Slice with specified size and capacity
    intslice3 := make([]int, 0, 8)
    intslice3 = append(intslice3, 5, 7, 9)
    fmt.Println(intslice3)
}
