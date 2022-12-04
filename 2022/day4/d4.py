import sys

def main():
    file = sys.argv[1]
    fd = open(file, "r")
    subsume = 0
    overlap = 0
    for line in fd:
        pairs = line.split(",")
        e1_range_raw = pairs[0].split("-")
        e2_range_raw = pairs[1].split("-")
        e1_range = [int(x) for x in e1_range_raw]
        e2_range = [int(x) for x in e2_range_raw]
        smaller = []
        larger = []
        if e1_range[1] - e1_range[0] < e2_range[1] - e2_range[0]:
            smaller = e1_range
            larger = e2_range
        else:
            smaller = e2_range
            larger = e1_range
        if smaller[0] >= larger[0] and smaller[1] <= larger[1]:
            subsume+=1
        # x1 <= y2 && y1 <= x2
        if smaller[0] <= larger[1] and larger[0] <= smaller[1]:
            overlap+=1
        
    print(subsume)
    print(overlap)
        

main()