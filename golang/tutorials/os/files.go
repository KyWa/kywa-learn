package main

import (
    "fmt"
    "os"
)
func CreateFile() {
	fmt.Println("Writing file")
	file, err := os.Create("test.txt")

	if err != nil {
		panic(err)
	}

	length, err := file.WriteString("welcome to golang" +
		"demonstrates reading and writing operations to a file in golang.")

	if err != nil {
		panic(err)
	}
	fmt.Printf("File name: %s", file.Name())
	fmt.Printf("\nfile length: %d\n", length)

    defer file.Close()
}

func ReadFile() {
	fmt.Println("Reading file")

	fileName := "test.txt"

	data, err := os.ReadFile(fileName)

	if err != nil {
		panic(err)
	}

	fmt.Println("file name " + fileName)
	fmt.Printf("file size %d\n", len(data))

    // fmt.Println for "data" will return not the actual contents, but the bytes structure of the file. You must use fmt.Printf("%s",data) to get the equivelant of "cat filename"
	fmt.Printf("file content:\n\n%s", data)

}

func main() {
	CreateFile()
	ReadFile()
}
