import sys
from itertools import takewhile


def lane(grid, x, y, x_dir, y_dir):
    w = len(grid[0])
    h = len(grid)
    xx = x + x_dir
    yy = y + y_dir
    while xx >= 0 and yy >= 0 and xx < w and yy < h:
        yield grid[xx][yy]
        xx += x_dir
        yy += y_dir


def score(grid, x, y):
    t = grid[x][y]

    def count(grid, x, y, x_dir, y_dir):
        t = grid[x][y]
        trees = list(lane(grid, x, y, x_dir, y_dir))
        if all(tt < t for tt in trees):
            return len(trees)
        else:
            return len(list(takewhile(lambda x: x < t, trees))) + 1

    visible = 1
    visible *= count(grid, x, y, 1, 0)
    visible *= count(grid, x, y, -1, 0)
    visible *= count(grid, x, y, 0, 1)
    visible *= count(grid, x, y, 0, -1)
    return visible


def main():
    grid = [[int(c) for c in l.strip()] for l in sys.stdin.readlines()]

    w = len(grid[0])
    h = len(grid)
    max_score = 0
    for x in range(w):
        for y in range(h):
            max_score = max(score(grid, x, y), max_score)
    print(max_score)


if __name__ == '__main__':
    main()
