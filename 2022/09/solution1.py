import sys
from collections import namedtuple


Point = namedtuple('Point', ['x', 'y'])


def move(head, d):
    D = {'R': (1, 0), 'L': (-1, 0), 'U': (0, 1), 'D': (0, -1)}
    dx, dy = D[d]
    return Point(head.x + dx, head.y + dy)


def is_adjacent(head, tail):
    x, y = head
    ps = [Point(x - 1, y - 1), Point(x, y - 1), Point(x + 1, y - 1),
         Point(x - 1, y), Point(x + 1, y),
         Point(x - 1, y + 1), Point(x, y + 1), Point(x + 1, y + 1)]
    return tail in ps


def follow(tail, head):
    if tail == head:
        return tail
    elif is_adjacent(head, tail):
        return tail
    elif tail.x == head.x:
        return Point(tail.x, tail.y - 1) if head.y < tail.y else Point(tail.x, tail.y + 1)
    elif tail.y == head.y:
        return Point(tail.x - 1, tail.y) if head.x < tail.x else Point(tail.x + 1, tail.y)
    else:
        x = tail.x - 1 if head.x < tail.x else tail.x + 1
        y = tail.y - 1 if head.y < tail.y else tail.y + 1
        return Point(x, y)


def main():
    head = Point(0, 0)
    tail = Point(0, 0)
    tail_visists = set()
    tail_visists.add(tail)
    for l in sys.stdin.readlines():
        d, n = l.strip().split(' ')
        n = int(n)
        for _ in range(n):
            head = move(head, d)
            tail = follow(tail, head)
            tail_visists.add(tail)
    print(len(tail_visists))


if __name__ == '__main__':
    main()
