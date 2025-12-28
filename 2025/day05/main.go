package main

import (
	"bufio"
	"fmt"
	"io"
	"math/big"
	"os"
	"strings"
)

type IntervalSet struct {
	intervals []*Interval
}

func (is *IntervalSet) Size() *big.Int {
	z := big.NewInt(0)
	for _, v := range is.intervals {
		if v == nil {
			continue
		}
		z.Add(z, v.Size())
	}

	return z
}

func (is *IntervalSet) String() string {
	var strs []string
	for _, iv := range is.intervals {
		if iv == nil {
			strs = append(strs, "nil")
		} else {
			strs = append(strs, iv.String())
		}
	}

	return strings.Join(strs, ",")
}

func (is *IntervalSet) InString(v string) bool {
	for _, iv := range is.intervals {
		if iv == nil {
			continue
		}
		if iv.InString(v) {
			return true
		}
	}
	return false
}

func (is *IntervalSet) Append(i *Interval) (bool, error) {
	if len(is.intervals) == 0 {
		is.intervals = []*Interval{i}
		return true, nil
	}
	// assume all existing intervals are disjoint
	fmt.Printf("appending %s\n", i.String())

	var overlaps []int
	for ix, iv := range is.intervals {
		if iv == nil {
			continue
		}
		if iv.In(i.Low) || iv.In(i.High) || i.In(iv.Low) || i.In(iv.High) {
			fmt.Printf("range %s is overlapping\n", iv.String())
			overlaps = append(overlaps, ix)
		}
	}

	// there are three ways to overlap -
	// old interval overlaps the lower part of the new interval
	// old inverval overlaps the higher part of the new interval
	// old interval is subsumed by the new interval
	// old interval subsumes the new interval
	//
	// If all intervals in the set are disjoint, only up to one interval can
	// be of type 1 and 2 each.
	var newLow, newHigh = i.Low, i.High
	for _, idx := range overlaps {
		oldInterval := is.intervals[idx]
		if oldInterval.In(i.Low) && oldInterval.In(i.High) {
			// type 4, don't append, nothing else to do
			return true, nil
		}
		if i.In(oldInterval.Low) && i.In(oldInterval.High) {
			// type 3, just tombstoned
			continue
		}
		if i.In(oldInterval.High) {
			// type 1, adjust bound to be old interval's low
			newLow = oldInterval.Low
			continue
		}
		if i.In(oldInterval.Low) {
			// type 2
			newHigh = oldInterval.High
			continue
		}
	}
	is.intervals = append(is.intervals, &Interval{
		Low:  newLow,
		High: newHigh,
	})
	for _, v := range overlaps {
		is.intervals[v] = nil
	}

	return false, nil
}

type Interval struct {
	Low  *big.Int
	High *big.Int
}

func (i *Interval) InString(v string) bool {
	bv := new(big.Int)
	bv.SetString(v, 10)
	return i.In(bv)
}

func (i *Interval) In(v *big.Int) bool {
	return i.Low.Cmp(v) <= 0 && i.High.Cmp(v) >= 0
}

func (i *Interval) String() string {
	return fmt.Sprintf("[%s-%s]", i.Low.String(), i.High.String())
}

func (i *Interval) Size() *big.Int {
	z := big.NewInt(0)
	return z.Sub(i.High, i.Low).Add(z, big.NewInt(1))
}

func main() {
	buf := bufio.NewReader(os.Stdin)

	intervals := &IntervalSet{}
	ingredientPhase := false
	count := 0
	for {
		line, err := buf.ReadString('\n')
		if err == io.EOF {
			break
		}
		if err != nil {
			panic(err)
		}
		if len(line) == 1 {
			ingredientPhase = true
			continue
		}
		if ingredientPhase {
			if intervals.InString(line) {
				count++
			}
		} else {
			vals := strings.Split(line, "-")
			low := new(big.Int)
			high := new(big.Int)
			low.SetString(vals[0], 10)
			high.SetString(vals[1], 10)
			intervals.Append(&Interval{
				Low:  low,
				High: high,
			})
			// fmt.Println(intervals)
		}
	}
	fmt.Printf("%d\n", count)
	fmt.Printf("%s\n", intervals.Size())
}
