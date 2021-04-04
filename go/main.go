package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"
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
			if !info.IsDir() {
				scanFile(path)
			}
			return nil
		})
	if err != nil {
		log.Println(err)
	}
}

func scanFile(filePath string) {
	file, err := os.Open(filePath)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	line := 1
	for scanner.Scan() {
		_, token, err := bufio.ScanLines([]byte(scanner.Text()), true)

		s := string(token)

		if err == nil && strings.Contains(s, "debugger") {

			fmt.Printf("%v - L%v : %v", filePath, line, s)
		}
		line++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
