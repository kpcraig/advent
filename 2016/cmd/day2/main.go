package main

import (
	"fmt"
	advent "github.com/kpcraig/advent/2016"
	"os"
)

// overengineer because we're not on a time crunch 8 years later
type Keypad struct {
	successors map[int32][]int
}

func KP1() Keypad {
	return Keypad{
		successors: map[int32][]int{
			'U': {1, 2, 3, 1, 2, 3, 4, 5, 6},
			'D': {4, 5, 6, 7, 8, 9, 7, 8, 9},
			'L': {1, 1, 2, 4, 4, 5, 7, 7, 8},
			'R': {2, 3, 3, 5, 6, 6, 8, 8, 9},
		},
	}
}

func KP2() Keypad {
	return Keypad{
		//     1
		//   2 3 4
		// 5 6 7 8 9
		//   A B C
		//     D
		successors: map[int32][]int{
			'U': {1, 2, 1, 4, 5, 2, 3, 4, 9, 6, 7, 8, 0xB},
			'D': {3, 6, 7, 8, 5, 0xA, 0xB, 0xC, 9, 0xA, 0xD, 0xC, 0xD},
			'L': {1, 2, 2, 3, 5, 5, 6, 7, 8, 0xA, 0xA, 0xB, 0xD},
			'R': {1, 3, 4, 4, 6, 7, 8, 9, 9, 0xB, 0xC, 0xC, 0xD},
		},
	}
}

func (k Keypad) Next(cmdList string, startKey int) int {
	key := startKey
	for _, dir := range cmdList {
		next := k.successors[dir]
		key = next[key-1]
	}
	return key
}

//func (k KeypadP2) Next(cmdList string, startKey int) int {
//	// left edge is 1, 2, 5, 10, 13
//	// right edge is 1, 4, 9, 12, 13
//	// top edge is 1, 2, 4, 5, 9
//	// bottom edge is 5 9 10 12 13
//	key := startKey
//	for _, dir := range cmdList {
//
//	}
//	return key
//}

func main() {
	input := os.Args[1]
	problem := os.Args[2]

	lines := advent.MustReadFile(input, true)
	key := 5
	var code []int
	var kp Keypad
	if problem == "1" {
		kp = KP1()
	} else {
		kp = KP2()
	}
	for _, line := range lines {
		key = kp.Next(line, key)
		code = append(code, key)
	}

	fmt.Printf("%+v\n", code)
}
