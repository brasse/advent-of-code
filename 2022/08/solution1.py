import sys

def lane(grid, x, y, x_dir, y_dir):
    w = len(grid[0])
    h = len(grid)
    xx = x + x_dir
    yy = y + y_dir
    while xx >= 0 and yy >= 0 and xx < w and yy < h:
        yield grid[xx][yy]
        xx += x_dir
        yy += y_dir


def main():
    grid = [[int(c) for c in l.strip()] for l in sys.stdin.readlines()]

    w = len(grid[0])
    h = len(grid)
    visible = 0
    for x in range(1, w - 1):
        for y in range(1, h - 1):
            t = grid[x][y]
            if (all(1 if tt < t else 0 for tt in lane(grid, x, y, 1, 0))
                or all(1 if tt < t else 0 for tt in lane(grid, x, y, -1, 0))
                or all(1 if tt < t else 0 for tt in lane(grid, x, y, 0, 1))
                or all(1 if tt < t else 0 for tt in lane(grid, x, y, 0, -1))):
                visible += 1
    print(visible + 2 * (w + h) - 4)


if __name__ == '__main__':
    main()
