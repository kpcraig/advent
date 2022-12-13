package advent

import (
	"bufio"
	"os"
	"strings"
)

func MustReadFile(filename string, trimNewline bool) []string {
	fd, err := os.Open(filename)
	if err != nil {
		panic(err)
	}

	in := bufio.NewReader(fd)
	var lines []string
	for {
		str, err := in.ReadString('\n') // this includes the delim, i.e., the newline in this case
		if err != nil {                 // probably eof, just advent of code things
			break
		}

		if trimNewline {
			lines = append(lines, strings.TrimSpace(str))
		} else {
			lines = append(lines, str)
		}
	}

	return lines
}
