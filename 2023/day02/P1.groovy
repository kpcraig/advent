import java.util.regex.Pattern

def linePattern = ~/Game (\d+):( \d+ (red|green|blue)[,;]?)+/
def cubePattern = ~/(\d+) (red|green|blue)/

def redMax = 12
def blueMax = 14
def greenMax = 13
def total = 0

def lines = System.in.readLines()
for(line: lines) {
  def lineMatch = line =~ linePattern
  def cubes = lineMatch[0][0];
  def game = lineMatch[0][1];
  def cubeMatch = cubes =~ cubePattern;
  def bad = false
  for(match: cubeMatch) {
    def color = match[2]
    def amt = match[1]
    switch(color) {
      case 'blue':
        if (amt.toInteger() > blueMax) {
          bad = true
        }
        break;
      case 'red':
        if (amt.toInteger() > redMax) {
          bad = true
        }
        break;
      case 'green':
        if (amt.toInteger() > greenMax) {
          bad = true
        }
        break;
    }
  }
  if(!bad) {
    total += game.toInteger()
  }
}
System.out.println(total)
