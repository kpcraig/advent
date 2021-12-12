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

	// best target i think is probably the rounded arithmetic mean?
	var sum int
	for _, v := range values {
		sum += v
	}

	avg := int(math.Round(float64(sum) / float64(len(values))))
	fmt.Println(avg)
	// I'll be honest I don't know how to pick which one.
	center := fuelCost(values, avg)
	high := fuelCost(values, avg+1)
	low := fuelCost(values, avg-1)

	p := []int{center, high, low}
	sort.Ints(p)
	fmt.Println(p[0])
}

func fuelCost(locations []int, target int) int {
	var sum int
	for _, v := range locations {
		distance := int(math.Abs(float64(target - v)))
		// cost is now the nth triangular number
		cost := distance * (distance + 1) / 2
		// fmt.Println("cost", cost)
		sum += cost
	}

	return sum
}
