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
        p0, _ := strconv.Atoi(matches[1])
        p1, _ := strconv.Atoi(matches[2])
        c := firstRune(matches[3])
        password := matches[4]
        if check(p0 - 1, p1 - 1, c, password) {
            n++;
        }
    }
    fmt.Println(n)
}

func check(p0 int, p1 int, c rune, password string) bool {
    runes := runes(password)
    check0 := runes[p0] == c
    check1 := runes[p1] == c
    return check0 && !check1 || !check0 && check1
}

func runes(s string) []rune {
    var runes []rune
    for _, r := range s {
        runes = append(runes, r)
    }
    return runes
}

func firstRune(s string) rune {
    var first rune
    for _, r := range s {
        first = r
        break
    }
    return first
}
