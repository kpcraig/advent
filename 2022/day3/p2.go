package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"
)

func main() {
	input := os.Args[1]

	// advent of code, so ignore all errors
	fd, _ := os.Open(input)

	in := bufio.NewReader(fd)
	var sc int
	for {

		matchSlice := make([]int, 52)

		e1, _ := in.ReadString('\n') // this includes the delim, i.e., the newline in this case
		e2, _ := in.ReadString('\n')
		e3, err := in.ReadString('\n')
		if err != nil { // probably eof, just advent of code things
			break
		}
		e1 = strings.TrimSpace(e1)
		e2 = strings.TrimSpace(e2)
		e3 = strings.TrimSpace(e3)

		// populate e1
		for _, v := range e1 {
			scr := score(byte(v))
			matchSlice[scr-1] = 1
		}

		for _, v := range e2 {
			scr := score(byte(v))
			if matchSlice[scr-1] == 1 {
				matchSlice[scr-1] = 2
			}
		}
		// fmt.Printf("%+v\n", matchSlice)
		for _, v := range e3 {
			scr := score(byte(v))
			if matchSlice[scr-1] == 2 {
				sc += scr
				fmt.Printf("%c\n", v)
				break
			}
		}
	}

	fmt.Printf("score: %d", sc)
}

func score(c byte) int {
	if c > 96 {
		return int(c - 96)
	} else {
		return int(c-64) + 26
	}
}
