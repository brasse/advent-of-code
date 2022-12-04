import sys


def priority(c):
    if c.islower():
        return ord(c) - ord('a') + 1
    else:
        return ord(c) - ord('A') + 27


def main():
    total_prio = 0

    for l in sys.stdin.readlines():
        l = l.strip()
        half = int(len(l)/2)
        s1 = set(l[:half])
        s2 = set(l[half:])
        c = s1.intersection(s2).pop()
        total_prio += priority(c)

    print(total_prio)


if __name__ == '__main__':
    main()
