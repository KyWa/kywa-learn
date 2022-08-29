package main

import "fmt"

func main() {
    // creating, declaring basic array
    var x [5]int
    x[4] = 100
    fmt.Println(x)

    // creating, declaring basic array
    var z [7]float64
    z[0] = 98
    z[1] = 93
    z[2] = 77
    z[3] = 82
    z[4] = 83
    z[5] = 100 
    z[6] = 99 

    // adding up array then dividing it
    var total float64 = 0
    for i := 0; i < 5; i++ {
        total += z[i]
    }
    fmt.Println(total / 5)

    // same as above but going by length of array rather than set number
    var newtotal float64 = 0
    for i := 0; i < len(z); i++ {
        newtotal += z[i]
    }
    // converts len(z) into float as len returns int and you cant divide float64 against int
    fmt.Println(newtotal / float64(len(z)))

    var totes float64 = 0
    // alternative array creation, declaration and set
    y := [7]float64{ 98, 93, 77, 82, 83, 100, 99}
    // _ is a special iterator that isn't needed and can be ignored
    for _, value := range y {
        totes += value
    }
    fmt.Println(totes / float64(len(y)))

    // declare array with no length
    array := []int{1,2,3}
    fmt.Println(array)

    // array append
    somearray := []int{1,2,3}
    somearray = append(somearray, 4, 5)
    fmt.Println(somearray)

    // map aka dict key/val
    m := make(map[string]int)
    m["key1"] = 42
    fmt.Println(m["key1"])

    ele := make(map[string]string)
    ele["k"] = "kay"
    ele["y"] = "yay"

    // print value that is there
    fmt.Println(ele["k"])

    // print value that isnt there
    fmt.Println(ele["rar"])
    
    // get value and if exists
    // maps can return 2 values, the value and a boolean on its existence
    name, ok := ele["k"]
    fmt.Println(name, ok)

    // get value and existence of nonexistent key
    name1, ok1 := ele["poop"]
    fmt.Println(name1, ok1)

    // try fun things
    if val, boole := ele["k"]; ok {
        fmt.Println(val, boole)
    }
}
