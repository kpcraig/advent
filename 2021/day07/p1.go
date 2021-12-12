package main

import (
	"bufio"
	"fmt"
	"math"
	"os"
	"sort"
	"strconv"
	"strings"
)

const filename = "input"

func main() {
	// ignore all errors just like in production
	fd, _ := os.Open(filename)

	r := bufio.NewReader(fd)
	line, _ := r.ReadString('\n')

	rawValues := strings.Split(strings.TrimRight(line, "\n"), ",")
	var values []int

	for _, rv := range rawValues {
		v, err := strconv.Atoi(rv)
		if err != nil {
			panic(err)
		}
		values = append(values, v)
	}

	sort.Ints(values)
	mid := len(values) / 2
	// shot in the dark
	fmt.Println(fuelCost(values, values[mid]))
}

func fuelCost(locations []int, target int) int {
	var sum int
	for _, v := range locations {
		cost := int(math.Abs(float64(target - v)))
		// fmt.Println("cost", cost)
		sum += cost
	}

	return sum
}
