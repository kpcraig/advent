import sys

peeks = 0
raster = [['.' for x in range(40)] for x in range(6)]

def pixel(cycle):
    column = (cycle-1) % 40
    row = ((cycle-1) / 40) % 6
    return column,int(row)

def noop():
    None

def peek(cycle, register):
    print(cycle, register, end='')
    if (cycle - 20) % 40 == 0:
        # print("peek", cycle, cycle * register)
        global peeks
        peeks += cycle * register
    column, row = pixel(cycle)
    crt_cycle = (cycle-1) % 40
    # global raster
    if register -1 == crt_cycle or register == crt_cycle or register+1 == crt_cycle:
        print("", column, crt_cycle,"#")
        raster[row][column] = '#'
    else:
        print()
        raster[row][column] = '.'

def main():
    file = sys.argv[1]
    fd = open(file, "r")
    cycle = 0
    register = 1
    for line in fd:
        cycle+=1
        pairs = line.split(" ")

        if pairs[0] == 'noop\n':
            peek(cycle, register) # during cycle
            noop()
        elif pairs[0] == 'addx':
            # print("addx", pairs[1])
            peek(cycle, register) # during first add cycle
            cycle+=1
            peek(cycle, register) # during second add cycle
            # if cycle - 19 % 40 == 0:
            #     peeks.append(register * (cycle + 1))
            register += int(pairs[1])
        else:
            print("what", line)

    print(peeks)

    for row in raster:
        for c in row:
            print(c, end='')
        print()

main()