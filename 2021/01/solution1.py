import sys


def main():
    increased = 0
    readings = [int(x) for x in sys.stdin.readlines()]
    prev = readings[0]
    for x in readings[1:]:
        if x > prev:
            increased += 1
        prev = x
    print(increased)


if __name__ == '__main__':
    main()
