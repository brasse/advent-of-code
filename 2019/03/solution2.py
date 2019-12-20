import sys

directions = {
    'R': (1, 0),
    'L': (-1, 0),
    'U': (0, 1),
    'D': (0, -1)
}

def run_wire(grid, wire, is_first):
    distances = []
    x = 0
    y = 0
    z = 0
    for stretch in wire:
        d = stretch[0]
        l = int(stretch[1:])
        dx, dy =  directions[d]
        for _ in range(l):
            x += dx
            y += dy
            z += 1
            if is_first:
                grid[(x, y)] = z
            if not is_first:
                if (x, y) in grid:
                    distances.append(z + grid[(x, y)])
    return distances

def main():
    w0 = sys.stdin.readline().split(',')
    w1 = sys.stdin.readline().split(',')

    grid = {}
    run_wire(grid, w0, True)
    distances = run_wire(grid, w1, False)
    print(min(distances))

if __name__  == '__main__':
    main()
