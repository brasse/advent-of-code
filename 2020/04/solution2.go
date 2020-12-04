package main

import "bufio"
import "fmt"
import "os"
import "regexp"
import "strconv"
import "strings"

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    n := 0
    
    for true {
        fields := getFields(scanner)
        if len(fields) == 0 {
            break
        }
        if (validate(fields)) {
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

func validate(f map[string]string) bool {
    return validateInt(f["byr"], 1920, 2002) &&
        validateInt(f["iyr"], 2010, 2020) &&
        validateInt(f["eyr"], 2020, 2030) &&
        validateHeight(f["hgt"]) &&
        validateHair(f["hcl"]) &&
        validateEye(f["ecl"]) &&
        validatePid(f["pid"])
}

func validateInt(s string, min int, max int) bool {
    if i, err := strconv.Atoi(s); err == nil {
        return i >= min && i <= max
    } else {
        return false
    }
}

func validateHeight(s string) bool {
    if strings.HasSuffix(s, "cm") {
        return validateInt(s[0:len(s) - 2], 150, 193)
    } else if strings.HasSuffix(s, "in") {
        return validateInt(s[0:len(s) - 2], 59, 76)
    } else {
        return false
    }
}

func validateHair(s string) bool {
    re := regexp.MustCompile(`^#[0-9a-f]{6}$`)
    return re.MatchString(s)
}

func validateEye(s string) bool {
    re := regexp.MustCompile(`^amb|blu|brn|gry|grn|hzl|oth$`)
    // c := map[string]bool{"amb": true, "blu": true, "brn": true, "gry" : true, "grn": true,
    //     "hzl": true, "oth": true}
    // return c[s]
    return re.MatchString(s)
}

func validatePid(s string) bool {
    re := regexp.MustCompile(`^[0-9]{9}$`)
    return re.MatchString(s)
}
