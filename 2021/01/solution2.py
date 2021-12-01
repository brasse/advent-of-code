import sys


def main():
    increased = 0
    readings = [int(x) for x in sys.stdin.readlines()]
    r0 = readings[0]
    r1 = readings[1]
    r2 = readings[2]
    for x in readings[3:]:
        prev = r0 + r1 + r2
        curr = r1 + r2 + x
        if curr > prev:
            increased += 1
        r0 = r1
        r1 = r2
        r2 = x
    print(increased)


if __name__ == '__main__':
    main()
