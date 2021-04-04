package main

import (
	"fmt"
	"log"
	"os"
	"path/filepath"
)

func main() {
	listDirectory("../target")
}

func listDirectory(target string) {
	err := filepath.Walk(target,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			fmt.Println(path, info.Size())
			return nil
		})
	if err != nil {
		log.Println(err)
	}
}
