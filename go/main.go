package main

import (
	"fmt"
	"io/ioutil"
	"log"
)

func main() {
	files, err := ioutil.ReadDir("../target")
	if err != nil {
		log.Fatal(err)
	}

	for _, f := range files {
		if f.IsDir() {
			fmt.Println("folder", f.Name())
			continue
		}
		fmt.Println("file", f.Name())
	}
}
