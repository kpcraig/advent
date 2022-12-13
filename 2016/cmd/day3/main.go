package main

import (
	"fmt"
	advent "github.com/kpcraig/advent/2016"
	"os"
	"regexp"
	"strconv"
)

var re = regexp.MustCompile(`(\d+)\s+(\d+)\s+(\d+)`)

func valid(s1, s2, s3 int) bool {
	return s1+s2 > s3 && s1+s3 > s2 && s2+s3 > s1
}

func toi(s []string) []int {
	var i []int
	for _, v := range s {
		n, _ := strconv.Atoi(v)
		i = append(i, n)
	}

	return i
}

func P1(lines []string) int {
	possible := 0
	for _, line := range lines {
		parts := re.FindStringSubmatch(line)
		var sides []int
		for _, v := range parts[1:] {
			val, _ := strconv.Atoi(v)
			sides = append(sides, val)
		}
		fmt.Println(sides)
		if valid(sides[0], sides[1], sides[2]) {
			possible += 1
		}
	}

	return possible
}

func P2(lines []string) int {
	possible := 0
	for i := 0; i < len(lines); i += 3 {
		l1 := re.FindStringSubmatch(lines[i])[1:]
		l2 := re.FindStringSubmatch(lines[i+1])[1:]
		l3 := re.FindStringSubmatch(lines[i+2])[1:]
		t1 := toi(l1)
		t2 := toi(l2)
		t3 := toi(l3)
		if valid(t1[0], t2[0], t3[0]) {
			possible += 1
		}
		if valid(t1[1], t2[1], t3[1]) {
			possible += 1
		}
		if valid(t1[2], t2[2], t3[2]) {
			possible += 1
		}
	}
	return possible
}

func main() {
	filename := os.Args[1]

	lines := advent.MustReadFile(filename, true)
	if os.Args[2] == "1" {
		fmt.Println(P1(lines))
	} else {
		fmt.Println(P2(lines))
	}
}
