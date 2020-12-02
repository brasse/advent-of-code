package main

import "bufio"
import "fmt"
import "os"
import "regexp"
import "strconv"

func main() {
    n := 0
    re := regexp.MustCompile(`([0-9]+)-([0-9]+) (.): (.+)`)
    scanner := bufio.NewScanner(os.Stdin)
    for scanner.Scan() {
        matches := re.FindStringSubmatch(scanner.Text())
        if len(matches) != 5 {
            os.Exit(1)
        }
        min, _ := strconv.Atoi(matches[1])
        max, _ := strconv.Atoi(matches[2])
        c := firstRune(matches[3])
        password := matches[4]
        if check(min, max, c, password) {
            n++;
        }
    }
    fmt.Println(n)
}

func check(min int, max int, c rune, password string) bool {
    n := count(password, c)
    return n >= min && n <=max 
}

func firstRune(s string) rune {
    var first rune
    for _, r := range s {
        first = r
        break
    }
    return first
}

func count(s string, c rune) int {
    n := 0
    for _, x := range s {
        if x == c {
            n++
        }
    }
    return n
}
