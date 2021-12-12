import java.nio.file.Files
import java.nio.file.Paths
import kotlin.collections.*


var input = "/Users/kpcraig/workspace/advent/2021/day11/input"
var sample = "/Users/kpcraig/workspace/advent/2021/day11/sample"

class Point(val i: Int, val j: Int) {
    override fun toString(): String {
        return "($i, $j)"
    }

    override fun equals(other: Any?): Boolean {
        if(!(other is Point)) {
            return false
        }
        val o = other as Point

        return o.i == i && o.j == j
    }

    override fun hashCode(): Int {
        var result = Integer.hashCode(i)
        result = 31 * result + Integer.hashCode(j)
        return result
    }
}

fun main() {
    var p = Paths.get(input)
    var lines = Files.readAllLines(p)

    // initialize
    val height = lines.size
    val width = lines[0].length

    var grid = Array<IntArray>(height) { IntArray(width) }
    lines.forEachIndexed { y, l ->
        l.forEachIndexed() { x, c ->
            grid[y][x] = c.digitToInt()
        }
    }

    var f = 0
    val size = grid.size * grid[0].size
    var gen = 1
    val targetGen = 100
    while(true) {
        val fi = generate(grid)
        f += fi
        if(gen == targetGen) {
            println("$f flashes by $targetGen")
        }
        if(fi == size) {
            println("all flashed on $gen")
            if(gen >= targetGen) {
                break;
            }
        }
        gen++
//        println("$i: $fi: $size")
    }
//
//    println(Arrays.deepToString(grid))
//    println(f)
}

// do a generation
fun generate(a: Array<IntArray>): Int {
    var flashList = ArrayList<Point>()
    var flashed = HashSet<Point>()
    var flashes = 0

    // intial increment
    a.forEachIndexed { i, ints ->
        ints.forEachIndexed { j, v ->
            a[i][j] = v + 1
            if(v+1 > 9) {
                flashList.add(Point(i, j))
                flashed.add(Point(i, j))
            }
        }
    }

    // do flash cascade
    while(flashList.isNotEmpty()) {
//        println("flashlist depth: ${flashList.size}")
        val p = flashList.removeAt(0)
        flashes++
//        println("popping $p")
        // look all around
        var points = arrayOf<Point>(
            Point(p.i-1, p.j-1),
            Point(p.i-1, p.j),
            Point(p.i-1, p.j+1),
            Point(p.i, p.j-1),
            Point(p.i, p.j+1),
            Point(p.i+1, p.j-1),
            Point(p.i+1, p.j),
            Point(p.i+1, p.j+1)
        )
        points.forEach {
            if(it.i < 0 || it.i >= a.size || it.j < 0 || it.j >= a[it.i].size) {
                return@forEach
            }
            val v = a[it.i][it.j]
            if(v >= 9 && !flashed.contains(it)) {
                flashList.add(it)
                flashed.add(it)
            }
            a[it.i][it.j] = v + 1
        }
    }

    // reset jellyfish
    a.forEachIndexed { i, ints ->
        ints.forEachIndexed { j, v ->
            if(v > 9) {
                a[i][j] = 0
            }
        }
    }

    return flashes
}

main()