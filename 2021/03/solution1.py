import sys


def main():
    MSB = 11
    report = [int(x, 2) for x in sys.stdin.readlines()]
    gamma = 0
    for pos in range(MSB, -1, -1):
        gamma = gamma << 1 | most_common(pos, report)
    epsilon = invert(gamma, MSB)
    print(gamma * epsilon)


def most_common(pos, report):
    ones = 0
    for x in report:
        if x & 1 << pos:
            ones += 1
    return 1 if ones > len(report) / 2 else 0


def invert(i, msb):
    x = 0
    for pos in range(msb, -1, -1):
        bit = i & (1 << pos)
        x = x << 1 | (0 if bit else 1)
    return x


if __name__ == '__main__':
    main()
