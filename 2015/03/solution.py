import sys


def run(l):
    pos = (0, 0)
    houses = set()
    houses.add(pos)
    for c in l:
        if c == '>':
            new_pos = (pos[0] + 1, pos[1])
        elif c == '<':
            new_pos = (pos[0] - 1, pos[1])
        elif c == '^':
            new_pos = (pos[0], pos[1] + 1)
        elif c == 'v':
            new_pos = (pos[0], pos[1] - 1)
        houses.add(new_pos)
        pos = new_pos
    return houses


def main():
    s = sys.stdin.read()

    print('1:', len(run(s)))
    print('2:', len(run(s[i] for i in range(0, len(s), 2)) | run(s[i] for i in range(1, len(s), 2))))

if __name__ == '__main__':
    main()
