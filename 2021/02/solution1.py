import sys


def main():
    instructions = [(x.split()[0], int(x.split()[1]))
                    for x in sys.stdin.readlines()]
    h = 0
    d = 0
    for (direction, x) in instructions:
        if direction == 'forward':
            h += x
        elif direction == 'down':
            d += x
        elif direction == 'up':
            d -= x
        else:
            raise RuntimeError()
    print(h * d)


if __name__ == '__main__':
    main()
