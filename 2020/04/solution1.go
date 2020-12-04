package main

import "bufio"
import "fmt"
import "os"
import "regexp"
import "strings"

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    n := 0
    
    for true {
        fields := getFields(scanner)
        if len(fields) == 0 {
            break
        }
        if contains(fields, "byr") && contains(fields, "iyr") && contains(fields, "eyr") &&
            contains(fields, "hgt") && contains(fields, "hcl") && contains(fields, "ecl") &&
            contains(fields, "pid") {
            n++
        }
    }

    fmt.Println(n)
}

func getFields(scanner *bufio.Scanner) map[string]string {
    re := regexp.MustCompile(`[^\s]+:[^\s]+`)

    m := make(map[string]string)

    for scanner.Scan() {
        l := scanner.Text()
        if l == "" {
            break
        }
        for _, f := range re.FindAllString(l, -1) {
            parts := strings.Split(f, ":")
            m[parts[0]] = parts[1]
        }
    }

    return m
}

func contains(m map[string]string, k string) bool {
    _, ok := m[k]
    return ok
}
