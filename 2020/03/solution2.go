package main

import "bufio"
import "fmt"
import "os"

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    var trees [][] bool
    for scanner.Scan() {
        l := scanner.Text()
        var row []bool
        for _, r := range l {
            tree := r == '#'
            row = append(row, tree)
        }
        trees = append(trees, row)
    }

    n := countTrees(1, 1, trees) *
        countTrees(3, 1, trees) *
        countTrees(5, 1, trees) *
        countTrees(7, 1, trees) *
        countTrees(1, 2, trees)

    
    fmt.Println(n)
}

func countTrees(right int, down int, trees [][]bool) int {
    x, y := 0, 0
    width := len(trees[0])
    n := 0
    
    for y < len(trees) {
        if trees[y][x % width] {
            n++
        }
        x += right
        y += down
    }

    return n
}
