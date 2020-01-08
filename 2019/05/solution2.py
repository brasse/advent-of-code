import sys


def get_pos_nums(num):
    pos_nums = []
    while num != 0:
        pos_nums.append(num % 10)
        num = num // 10
    return pos_nums

def get(op, pos):
    if pos < len(op):
        return op[pos]
    else:
        return 0

def read(mem, mode, p):
    if mode == 1:
        return p
    elif mode == 0:
        return mem[p]

def main():
    p = [int(s) for s in sys.stdin.readline().split(',')]
    i = 0
    while True:
        op = get_pos_nums(p[i])

        opcode = get(op, 0) + 10 * get(op, 1)

        if opcode == 1:
            p[p[i + 3]] = read(p, get(op, 2), p[i + 1]) + read(p, get(op, 3), p[i + 2])
            i += 4
        elif opcode == 2:
            p[p[i + 3]] = read(p, get(op, 2), p[i + 1]) * read(p, get(op, 3), p[i + 2])
            i += 4
        elif opcode == 3:
            p[p[i + 1]] = 5
            i += 2
        elif opcode == 4:
            print(read(p, get(op, 2), p[i + 1]))
            i += 2
        elif opcode == 5:
            if read(p, get(op, 2), p[i + 1]):
                i = read(p, get(op, 3), p[i + 2])
            else:
                i += 3
        elif opcode == 6:
            if read(p, get(op, 2), p[i + 1]) == 0:
                i = read(p, get(op, 3), p[i + 2])
            else:
                i += 3
        elif opcode == 7:
            if read(p, get(op, 2), p[i + 1]) < read(p, get(op, 3), p[i + 2]):
                p[p[i + 3]] = 1
            else:
                p[p[i + 3]] = 0
            i += 4
        elif opcode == 8:
            if read(p, get(op, 2), p[i + 1]) == read(p, get(op, 3), p[i + 2]):
                p[p[i + 3]] = 1
            else:
                p[p[i + 3]] = 0
            i += 4
        elif opcode == 99:
            break
        else:
            raise RuntimeError()

if __name__  == '__main__':
    main()
