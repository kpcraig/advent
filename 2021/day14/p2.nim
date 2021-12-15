#[
comment test
#]#
import std/re
import std/tables
# import std/sequtils

proc incrOrAmt(tbl: var Table[string,uint64], key: string, amt: uint64 = 1) =
    if not tbl.hasKey(key):
        tbl[key] = 0
    tbl[key] += amt

proc generate(occs: var Table[string,uint64], rules: Table[string, string]): Table[string,uint64] =
    result = initTable[string,uint64]()
    for k, v in occs:
        # k is the pair, v is the count
        # for every pair get the rule
        let target = rules[k]
        # echo k, " -> ", target
        let k1 = k[0] & target
        let k2 = target & k[1]
        # echo k1, " ", k2, " ", v
        incrOrAmt(result, k1, v)
        incrOrAmt(result, k2, v)

proc countOccs(occs: Table[string,uint64], start: string, last: string): seq[uint64] =
    var count = initTable[string, uint64]()
    count[start] = 1
    count[last] = 1

    for k, v in occs:
        let k1 = $(k[0])
        let k2 = $(k[1])
        incrOrAmt(count, k1, v)
        incrOrAmt(count, k2, v)

    for k, v in count:
        result.add(v div 2)
    

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

var occs = initTable[string, uint64]()
for i in countup(0, start.len() - 2):
    let key = start[i] & start[i+1]
    if not occs.hasKey(key):
        occs[key] = 0
    occs[key] = occs[key]+1

for i in countup(1,40):
    occs = generate(occs, rules)

let t = countOccs(occs, $start[0], $start[start.len()-1])
echo t

let lg = max(t)
let sm = min(t)

echo (lg - sm)

