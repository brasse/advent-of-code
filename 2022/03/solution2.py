import sys


def priority(c):
    if c.islower():
        return ord(c) - ord('a') + 1
    else:
        return ord(c) - ord('A') + 27


def main():
    total_prio = 0

    rucksaks = [l.strip() for l in sys.stdin.readlines()]
    groups = [rucksaks[g:g + 3] for g in range(0, len(rucksaks), 3)]
    for group in groups:
        c = set(group[0]).intersection(set(group[1])).intersection(set(group[2])).pop()
        total_prio += priority(c)

    print(total_prio)


if __name__ == '__main__':
    main()
