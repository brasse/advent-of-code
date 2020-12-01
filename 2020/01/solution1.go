package main

import "bufio"
import "fmt"
import "os"
import "strconv"

func main() {
    var l []int
    scanner := bufio.NewScanner(os.Stdin)
    for scanner.Scan() {
        i, err := strconv.Atoi(scanner.Text())
        if err != nil {
            os.Exit(1)
        }
        l = append(l, i)
    }

    for x := 0; x < len(l); x++ {
        for y := x + 1; y < len(l); y++ {
            if l[x] + l[y] == 2020 {
                fmt.Println(l[x] * l[y])
            }
        }
    }
}
