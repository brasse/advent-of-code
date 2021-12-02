import sys


def main():
    instructions = [(x.split()[0], int(x.split()[1]))
                    for x in sys.stdin.readlines()]
    aim = 0
    h = 0
    d = 0
    for (direction, x) in instructions:
        if direction == 'forward':
            h += x
            d += aim * x
        elif direction == 'down':
            aim += x
        elif direction == 'up':
            aim -= x
        else:
            raise RuntimeError()
    print(h * d)


if __name__ == '__main__':
    main()
