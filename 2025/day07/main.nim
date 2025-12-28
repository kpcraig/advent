import std/cmdline
import std/syncio
import std/strutils
# import std/sets

let name = paramStr(1)
let f = open(name)
var line = readLine(f)
# find the S
var laser = newSeq[int](len(line))
let sdx = find(line, "S")
laser[sdx] = 1
var splitCount = 0
echo laser
while line != "":
  try:
    line = readLine(f)
    echo line
    for index in 0..len(laser)-1:
      # echo line[index]
      if laser[index] > 0 and line[index] == '^': 
        splitCount += 1
        laser[index-1] += laser[index]
        laser[index+1] += laser[index]
        laser[index] = 0
  except EOFError:
    break

var universes = 0
for v in laser:
  universes += v

echo "splits ", splitCount, " lasers ", universes
