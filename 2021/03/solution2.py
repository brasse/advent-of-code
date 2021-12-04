import operator
import sys


def main():
    MSB = 11
    report = [int(x, 2) for x in sys.stdin.readlines()]
    oxygen = find(report, operator.gt, 1, MSB)
    co2 = find(report, operator.lt, 0, MSB)
    print(oxygen * co2)


def most_common(pos, report, op, default):
    zeros = 0
    ones = 0
    for x in report:
        if x & 1 << pos:
            ones += 1
        else:
            zeros += 1
    if op(ones, zeros):
        return 1
    elif op(zeros, ones):
        return 0
    else:
        return default


def filter(pos, value, report):
    return [v for v in report if (v & (1 << pos)) == (value << pos)]


def find(report, op, default, msb):
    for pos in range(msb, -1, -1):
        report = filter(pos, most_common(pos, report, op, default), report)
        if len(report) == 1:
            return report[0]


if __name__ == '__main__':
    main()
