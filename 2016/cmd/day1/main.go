package main

import (
	"fmt"
	advent "github.com/kpcraig/advent/2016"
	"os"
	"regexp"
	"strconv"
	"strings"
)

const (
	FacingNorth = iota
	FacingEast
	FacingSouth
	FacingWest
)

var re = regexp.MustCompile(`([LR])(\d+)`)

func see(x, y int) string {
	return fmt.Sprintf("%d, %d", x, y)
}

func p2(lines []string) int {
	x, y := 0, 0
	facing := FacingNorth
	visited := make(map[string]struct{})
	visited[see(x, y)] = struct{}{}

	commands := strings.Split(lines[0], ", ")
	for _, cmd := range commands {
		matches := re.FindStringSubmatch(cmd)
		switch matches[1] {
		case "R":
			facing = (facing + 1) % 4
		case "L":
			facing = (facing - 1 + 4) % 4
		}

		distance, err := strconv.Atoi(matches[2])
		if err != nil {
			panic(err)
		}
		switch facing {
		case FacingNorth:
			for i := 0; i < distance; i++ {
				y += 1
				key := see(x, y)
				if _, ok := visited[key]; ok {
					return abs(x) + abs(y)
				} else {
					visited[key] = struct{}{}
				}
			}
		case FacingSouth:
			for i := 0; i < distance; i++ {
				y -= 1
				key := see(x, y)
				if _, ok := visited[key]; ok {
					return abs(x) + abs(y)
				} else {
					visited[key] = struct{}{}
				}
			}
		case FacingEast:
			for i := 0; i < distance; i++ {
				x += 1
				key := see(x, y)
				if _, ok := visited[key]; ok {
					return abs(x) + abs(y)
				} else {
					visited[key] = struct{}{}
				}
			}
		case FacingWest:
			for i := 0; i < distance; i++ {
				x -= 1
				key := see(x, y)
				if _, ok := visited[key]; ok {
					return abs(x) + abs(y)
				} else {
					visited[key] = struct{}{}
				}
			}
		}
	}

	return abs(x) + abs(y)
}

func p1(lines []string) int {

	x, y := 0, 0
	facing := FacingNorth

	commands := strings.Split(lines[0], ", ")
	for _, cmd := range commands {
		matches := re.FindStringSubmatch(cmd)
		switch matches[1] {
		case "R":
			facing = (facing + 1) % 4
		case "L":
			facing = (facing - 1 + 4) % 4
		}

		distance, err := strconv.Atoi(matches[2])
		if err != nil {
			panic(err)
		}
		switch facing {
		case FacingNorth:
			y += distance
		case FacingSouth:
			y -= distance
		case FacingEast:
			x += distance
		case FacingWest:
			x -= distance
		}

	}
	return abs(x) + abs(y)
}

func main() {
	input := os.Args[1]
	problem := os.Args[2]

	lines := advent.MustReadFile(input, false)

	var v int
	if problem == "1" {
		v = p1(lines)
	} else {
		v = p2(lines)
	}

	fmt.Println(v)
}

func abs(x int) int {
	if x < 0 {
		return -x
	} else {
		return x
	}
}
