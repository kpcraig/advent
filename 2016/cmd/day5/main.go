package main

import (
	"bytes"
	"crypto/md5"
	"fmt"
	advent "github.com/kpcraig/advent/2016"
	"io"
	"os"
)

func main() {
	filename := os.Args[1]
	line := advent.MustReadFile(filename, true)[0]

	fmt.Println(line)

	m5 := md5.New()
	var p1 bytes.Buffer
	p2 := make([]byte, 8)
	p2fill := make(map[int]struct{})
	for i := 0; i > -1; i++ {
		line := fmt.Sprintf("%s%d", line, i)
		io.WriteString(m5, line)
		bt := m5.Sum(nil)[:4]
		if bt[0] == 0 && bt[1] == 0 && bt[2] < 0x10 {
			// always write p1
			if p1.Len() < 8 {
				p1.WriteString(fmt.Sprintf("%x", bt[2]))
			}
			// write p2 if the index is valid
			if bt[2] < 8 && len(p2fill) < 8 {
				idx := int(bt[2])
				if _, ok := p2fill[idx]; ok {
					continue
				}
				p2[idx] = fmt.Sprintf("%x", (bt[3]&0xf0)>>4)[0]
				p2fill[idx] = struct{}{}
			}

		}
		m5.Reset()
		if p1.Len() == 8 && len(p2fill) == 8 {
			break
		}
	}

	fmt.Println(p1.String())
	fmt.Printf(string(p2))
}
