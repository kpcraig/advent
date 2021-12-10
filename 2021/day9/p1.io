highest := 9999
a := List clone

f := File with("input") openForReading
loop(
    s := f readLine
    t := List clone
    if(s == nil, break)
    s foreach(i, c, t append(c - 48)) // -48 converts from ascii to digit
    a append(t)
)
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