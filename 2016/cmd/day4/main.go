package main

import (
	"bytes"
	"fmt"
	advent "github.com/kpcraig/advent/2016"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

var re = regexp.MustCompile(`([a-z\-]+)(\d+)\[([a-z]+)]`)

func main() {
	filename := os.Args[1]

	lines := advent.MustReadFile(filename, true)
	sectorTotal := 0
	for _, v := range lines {
		split := re.FindStringSubmatch(v)
		//fmt.Printf("%+v\n", split)
		// 1 is the code, 2 is the sector, 3 is the checksum
		code := split[1]
		sector, _ := strconv.Atoi(split[2])
		checksum := split[3]
		if validate(code, checksum) {
			// how was i supposed to know this was the name?
			if name := decrypt(code, sector); strings.TrimSpace(name) == "northpole object storage" {
				fmt.Println(name, sector)
			}
			sectorTotal += sector
		}
	}

	fmt.Println(sectorTotal)
}

func decrypt(code string, sector int) string {
	var buf bytes.Buffer
	for _, c := range code {
		if c == '-' {
			buf.WriteByte(' ')
			continue
		}
		d := (((c - 'a') + int32(sector)) % 26) + 'a'
		if d > 'z' {
			d = 'a'
		}
		buf.WriteByte(byte(d))
	}

	return buf.String()
}

type pair struct {
	c byte
	f int // frequency
}

func (p pair) String() string {
	return fmt.Sprintf("{%c %d}", p.c, p.f)
}

type pairs []pair

func (p pairs) Len() int {
	return len(p)
}

func (p pairs) Less(i, j int) bool {
	// a pair is greater if its freq is greater, then if equal if its letter is earlier
	// a pair is less if its freq is less, then if equal if its letter is later (which is actually larger)
	iC := p[i].c
	iF := p[i].f
	jC := p[j].c
	jF := p[j].f

	if iF < jF {
		//fmt.Printf("i fthink %v is less than %v\n", p[i], p[j])
		return true
	} else if iF > jF {
		return false
	}
	if iC > jC {
		//fmt.Printf("i cthink %v is less than %v\n", p[i], p[j])
		return true
	} else if iC < jC {
		return false
	}

	return false
}

func (p pairs) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func validate(code, checksum string) bool {
	letterFreq := make(map[byte]pair)
	var buf bytes.Buffer
	for _, v := range code {
		if v == '-' {
			continue
		}
		if p, ok := letterFreq[byte(v)]; ok {
			letterFreq[byte(v)] = pair{p.c, p.f + 1}
		} else {
			letterFreq[byte(v)] = pair{byte(v), 1}
		}
	}

	var ps pairs
	for _, v := range letterFreq {
		ps = append(ps, v)
	}

	sort.Sort(sort.Reverse(ps))
	for i := 0; i < 5; i++ {
		buf.WriteByte(ps[i].c)
	}

	//fmt.Println(code, checksum, buf.String())

	return buf.String() == checksum
}
