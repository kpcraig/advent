package main

import "core:text/regex/virtual_machine"
import "core:strconv"
import "core:fmt"
import "core:os"
import "core:strings"
import "core:math"
import "core:math/linalg"
import "core:slice"

Box :: struct {
  loc: linalg.Vector3f64,
  circuit: int,
}

main :: proc() {
  name := os.args[1]
  // if this is -1, go until there's only one circuit
  joins, _ := strconv.parse_int(os.args[2])
  bt, ok := os.read_entire_file_from_filename(name, context.allocator)
  defer delete(bt, context.allocator)

  boxen: [dynamic]Box

  it := string(bt)
	for line in strings.split_lines_iterator(&it) {
		parts := strings.split(line, ",")
    x, _ := strconv.parse_int(parts[0])
    y, _ := strconv.parse_int(parts[1])
    z, _ := strconv.parse_int(parts[2])
    box := Box{loc=[3]f64{f64(x),f64(y),f64(z)},circuit=0}
    append(&boxen, box)
	}

  fmt.printf("args: %s, %d\n", name, joins)
  fmt.printf("boxen: %d\n", len(boxen))

  // do naive grouping
  direct_pairs := make(map[[2]int]bool)
  next_circuit := 1
  join_count := 0
  for {
    dist := max(f64)
    first_box, second_box: int
    for j := 0;j < len(boxen)-1; j+=1 {
      for k := j+1;k < len(boxen);k += 1 {
        if direct_pairs[[2]int{j,k}] == true {
          continue
        }
        d := linalg.distance(boxen[j].loc, boxen[k].loc)
        if d < dist {
          first_box = j
          second_box = k
          dist = d
        }
      }
    }
    fmt.printf("closest: %d, %d\n", first_box, second_box)
    first_circuit, second_circuit := boxen[first_box].circuit, boxen[second_box].circuit
    direct_pairs[[2]int{first_box, second_box}] = true
    if first_circuit != 0 && first_circuit == second_circuit {
      join_count += 1
      if joins != -1 && join_count >= joins {
        break
      }
      continue
    }
    fmt.printf("box one on circuit %d, box two on circuit %d\n", first_circuit, second_circuit)
    if first_circuit != 0 {
      if second_circuit != 0 {
        // become first circuit, with rename
        for &box in boxen {
          if box.circuit == second_circuit {
            fmt.printf("putting circuit %d on circuit %d\n", second_circuit, first_circuit)
            box.circuit = first_circuit
          }
        }
      } else {
        fmt.printf("putting box %d on circuit %d\n", second_box, first_circuit)
        boxen[second_box].circuit = first_circuit
      }
    } else {
      if second_circuit != 0 {
        fmt.printf("putting box %d on circuit %d\n", first_box, second_circuit)
        boxen[first_box].circuit = second_circuit
      } else {
        fmt.printf("allocating circuit %d\n", next_circuit)
        boxen[first_box].circuit = next_circuit
        boxen[second_box].circuit = next_circuit
        next_circuit += 1
      }
    }
    cs := make([dynamic]int, next_circuit)
    for box in boxen {
      cs[box.circuit] += 1
    }
    fmt.printf("circuits: %v\n", cs)
    found := false
    for c in cs[1:] {
      if joins == -1 && c == len(boxen) {
        fmt.printf("last boxes %v and %v: %d\n", boxen[first_box], boxen[second_box], boxen[first_box].loc[0] * boxen[second_box].loc[0])
        found = true
      }
    }
    if found {
      break
    }

    join_count += 1
    if joins != -1 && join_count >= joins {
      break
    }
  }

  circuit_sizes := make([dynamic]int, next_circuit)
  for box in boxen {
    circuit_sizes[box.circuit] += 1
  }
  fmt.printf("%v\n", circuit_sizes)
  circuit_sizes[0] = 0
  slice.reverse_sort(circuit_sizes[:])
  fmt.printf("value: %d (%d, %d, %d)\n", circuit_sizes[0]*circuit_sizes[1]*circuit_sizes[2], circuit_sizes[0],circuit_sizes[1],circuit_sizes[2])
}
