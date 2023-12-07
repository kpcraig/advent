import java.util.regex.Pattern

def linePattern = ~/Game (\d+):( \d+ (red|green|blue)[,;]?)+/
def cubePattern = ~/(\d+) (red|green|blue)/

def total = 0

def lines = System.in.readLines()
for(line: lines) {
  def minBlue = 0
  def minRed = 0
  def minGreen = 0
  def lineMatch = line =~ linePattern
  def cubes = lineMatch[0][0];
  def game = lineMatch[0][1];
  def cubeMatch = cubes =~ cubePattern;
  for(match: cubeMatch) {
    def color = match[2]
    def amt = match[1].toInteger()
    switch(color) {
      case 'blue':
        if (amt > minBlue) {
          minBlue = amt
        }
        break;
      case 'red':
        if (amt > minRed) {
          minRed = amt
        }
        break;
      case 'green':
        if (amt.toInteger() > minGreen) {
          minGreen = amt
        }
        break;
    }
  }
  def power = minBlue * minRed * minGreen
  System.out.println("game " + game + ":" + power)
  total += power
}
System.out.println(total)
