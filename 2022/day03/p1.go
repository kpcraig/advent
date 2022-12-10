package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	input := os.Args[1]

	// advent of code, so ignore all errors
	fd, _ := os.Open(input)

	in := bufio.NewReader(fd)
	var sc int
	for {

		matchSlice := make([]bool, 52)

		str, err := in.ReadString('\n') // this includes the delim, i.e., the newline in this case
		if err != nil {                 // probably eof, just advent of code things
			break
		}
		sz := len(str)
		front := str[:sz/2]
		back := str[sz/2 : sz-1]
		fmt.Printf("%s:%s", front, back)
		// populate with front
		for _, v := range front {
			scr := score(byte(v))
			matchSlice[scr-1] = true
		}
		// fmt.Printf("%+v\n", matchSlice)
		for _, v := range back {
			scr := score(byte(v))
			if matchSlice[scr-1] {
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
