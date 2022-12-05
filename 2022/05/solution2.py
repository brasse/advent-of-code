import re
import sys
from queue import LifoQueue


def get_stacks():
    parsed_items = {}
    n = 0
    while True:
        l = sys.stdin.readline()
        if not '[' in l:
            break
        for i, j in enumerate(range(1, len(l), 4)):
            n = max(n, i)
            c = l[j]
            if c != ' ':
                items = parsed_items.get(i, LifoQueue())
                items.put(c)
                parsed_items[i] = items

    stacks = []
    for i in range(n + 1):
        items = parsed_items[i]
        stack = []
        while not items.empty():
            stack.append(items.get_nowait())
        stacks.append(stack)
    sys.stdin.readline()
    return stacks


def get_moves():
    moves = []
    for l in sys.stdin.readlines():
        m = re.match(r'move (\d+) from (\d+) to (\d+)', l)
        if m:
            moves.append((int(m.group(1)), int(m.group(2)) - 1, int(m.group(3)) - 1))
        else:
            raise RuntimeError('no match!')
    return moves


def main():
    stacks = get_stacks()
    moves = get_moves()

    for m in moves:
        items = stacks[m[1]][-m[0]:]
        stacks[m[1]] = stacks[m[1]][:-m[0]]
        stacks[m[2]] = stacks[m[2]] + items

    print(''.join(stack.pop() for stack in stacks))


if __name__ == '__main__':
    main()
