package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type Point struct {
	X int
	Y int
}

var lineEx = regexp.MustCompile(`([ULDR]) (\d+)`)

func main() {
	input := os.Args[1]
	knotCount, _ := strconv.Atoi(os.Args[2])

	// advent of code, so ignore all errors
	fd, _ := os.Open(input)

	in := bufio.NewReader(fd)

	visited := make(map[Point]struct{})
	knots := make([]Point, knotCount) // 0 is head, 9 is final tail

	for {
		line, err := in.ReadBytes('\n') // this includes the delim, i.e., the newline in this case
		if err != nil {
			break // EOF
		}

		parts := lineEx.FindStringSubmatch(string(line))
		direction := parts[1]
		distance, _ := strconv.Atoi(parts[2])

		for i := 0; i < distance; i++ {

			switch direction {
			case "U":
				knots[0].Y = knots[0].Y + 1
			case "D":
				knots[0].Y = knots[0].Y - 1
			case "L":
				knots[0].X = knots[0].X - 1
			case "R":
				knots[0].X = knots[0].X + 1
			}

			// adjust tail
			for i := 1; i < len(knots); i++ {
				knots[i].X, knots[i].Y = move(knots[i-1], knots[i])
			}

			// done moving?
			visited[knots[len(knots)-1]] = struct{}{}
		}
	}

	fmt.Println(len(visited))
}

func abs(delta int) int {
	if delta < 0 {
		return -delta
	}

	return delta
}

func move(head, tail Point) (x, y int) {
	hx, hy := head.X, head.Y
	tx, ty := tail.X, tail.Y
	deltax := abs(hx - tx)
	deltay := abs(hy - ty)
	if deltax < 2 && deltay < 2 {
		return tx, ty // no movement
	}
	x, y = tx, ty
	// generally now, if t_ is < h_, t_ is plussed, and if t_ is > h_, t_ is minused
	if tx > hx {
		x -= 1
	} else if tx < hx {
		x += 1
	}

	if ty > hy {
		y -= 1
	} else if ty < hy {
		y += 1
	}

	return x, y
}
