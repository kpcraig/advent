highest := 9
a := List clone
lakes := List clone
queue := List clone

point := Object clone
point x ::= nil
point y ::= nil

f := File with("input") openForReading
loop(
    s := f readLine
    t := List clone
    if(s == nil, break)
    s foreach(i, c, t append(c - 48)) // -48 converts from ascii to digit
    a append(t)
)
// a foreach(i, v, writeln(a at(i)))

up := 0
down := 0
left := 0
right := 0

maxX := a size - 1
maxY := a at(0) size - 1
fillValue := 0

a foreach(x, v, 
    v foreach(y, w, 
        // x, y are list 'coords', v is the inner list, i.e., 'y-column', w is the actual cell value
        if(w < 0 or w == 9, continue) // we've 'visited' this cell because it's filled, or it's 9, which can't be part of a fill.
        // flood fill
        queue empty append(point clone setX(x) setY(y))
        fillSize := 0
        fillValue = fillValue - 1
        
        while(queue size > 0, 
            p := queue at(0)
            queue removeAt(0)


            px := p x
            py := p y
            val := a at(px) at(py)
            if(val < 0 or val == 9, continue)

            a at(px) atPut(py, fillValue)
            fillSize = fillSize + 1

            right := if(px < maxX, a at(px+1) at(py), highest)
            if(right >= 0 and right < 9, 
                queue append(point clone setX(px+1) setY(py))
            )

            left := if(px > 0, a at(px-1) at(py), highest)
            if(left >= 0 and left < 9, 
                queue append(point clone setX(px-1) setY(py))
            )

            down := if(py < maxY, a at(px) at(py+1), highest)
            if(down >= 0 and down < 9,
                queue append(point clone setX(px) setY(py+1))
            )

            up := if(py > 0, a at(px) at(py-1), highest)
            if(up >= 0 and up < 9,
                queue append(point clone setX(px) setY(py-1))
            )
        )

        lakes append(fillSize)
    )
)

// a foreach(i, v, writeln(a at(i)))

lakes sortInPlace reverseInPlace

// writeln(lakes)
writeln(lakes at(0) * lakes at(1) * lakes at(2))