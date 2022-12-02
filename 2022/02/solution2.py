import sys


def read_calories():
    elf = []
    for l in sys.stdin.readlines():
        l = l.strip()
        if l:
            elf.append(int(l))
        else:
            yield elf
            elf = []
        if l is None:
            break


def main():
    total_score = 0
    for l in sys.stdin.readlines():
        l = l.strip()
        if l in ['A Y', 'B X', 'C Z']:
            action = 'A'
        elif l in ['A Z', 'B Y', 'C X']:
            action = 'B'
        else:
            action = 'C'

        if l[2] == 'X':
            score = 0
        elif l[2] == 'Y':
            score = 3
        else:
            score = 6

        if action == 'A':
            score += 1
        elif action == 'B':
            score += 2
        else:
            score += 3
        print(score)

        total_score += score

    print(total_score)


if __name__ == '__main__':
    main()
