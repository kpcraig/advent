highest := 9999

a := List clone
// a append(List clone append(1,2,3), List clone append(4,5,6))
// 2199943210
// 3987894921
// 9856789892
// 8767896789
// 9899965678
// a append(
//     List clone append(2,1,9,9,9,4,3,2,1,0),
//     List clone append(3,9,8,7,8,9,4,9,2,1),
//     List clone append(9,8,5,6,7,8,9,8,9,2),
//     List clone append(8,7,6,7,8,9,6,7,8,9),
//     List clone append(9,8,9,9,9,6,5,6,7,8)
// )
f := File with("input") openForReading
loop(
    s := f readLine
    t := List clone
    if(s == nil, break)
    s foreach(i, c, t append(c - 48))
    a append(t)
)
// writeln(a)
sum := 0

up := 0
down := 0
left := 0
right := 0

a foreach(x, v, 
    v foreach(y, w, 
        maxX := a size - 1
        maxY := v size - 1
        right := if(x < maxX, a at(x+1) at(y), highest)
        left := if(x > 0, a at(x-1) at(y) , highest)
        down := if(y < maxY, v at(y+1), highest)
        up := if(y > 0, v at(y-1), highest)
        sum = sum + if(w < right and w < left and w < up and w < down, w + 1, 0)
    )
)

writeln(sum)