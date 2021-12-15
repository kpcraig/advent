import std/re
import std/tables
# import std/sequtils

proc generate(s: string, rules: Table[string, string]): string =
    # result = s
    # result.insert("lol", 1)
    # echo result
    var inserts = newSeq[int](0)
    var toInsert = newSeq[string](0)
    var idx = 0
    var insertPoint = 1
    while idx < s.len() - 1:
        let key = s[idx] & s[idx+1]
        let prod = rules[key]
        inserts.add(insertPoint)
        toInsert.add(prod)
        idx+=1
        insertPoint+=2
    
    result = s
    # echo inserts
    # echo toInsert
    # now do the inserts
    for i, v in inserts:
        # echo "i is", i, "and v is ", v
        result.insert(toInsert[i], v)


# let name = "sample"
let name = "input"

let ruleRX = re"([A-Z][A-Z]) -> ([A-Z])"

# maps from letter sequence to insertion character
var rules = initTable[string, string]()
var start: string

for l in name.lines:
    var matches: array[2, string]
    if match(l, ruleRX, matches):
        rules[matches[0]] = matches[1]
    elif l.len() > 0:
        start = l

for i in countup(1,40):
    start = generate(start, rules)

let t = toCountTable(start)

let lg = largest(t)
let sm = smallest(t)

echo (lg.val - sm.val)