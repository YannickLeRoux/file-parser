package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	fmt.Println(os.Args[1])
	listDirectory(os.Args[1])
}

func listDirectory(target string) {
	err := filepath.Walk(target,
		func(path string, info os.FileInfo, err error) error {
			check(err)

			if !info.IsDir() {
				scanFile(path)
			}
			return nil
		})
	check(err)
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

		check(err)

		s := string(token)

		for _, word := range getWords() {
			if strings.Contains(s, word) {

				fmt.Printf("%v - L%v : %v \n", filePath, line, s)
			}

		}

		line++
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}

func check(err error) {
	if err != nil {
		panic(err)
	}
}

func getWords() []string {
	data, err := ioutil.ReadFile("../words.txt")
	check(err)
	return strings.Split(string(data), "\n")

}
