import sys


def run(prog, noun, verb):
    p = prog.copy()
    p[1] = noun
    p[2] = verb
    i = 0
    while True:
        if p[i] == 99:
            break
        elif p[i] == 1:
            p[p[i + 3]] = p[p[i + 1]] + p[p[i + 2]]
            i += 4
        elif p[i] == 2:
            p[p[i + 3]] = p[p[i + 1]] * p[p[i + 2]]
            i += 4
        else:
            raise RuntimeError()
    return p[0]


def main():
    prog = [int(s) for s in sys.stdin.readline().split(',')]
    for noun in range(100):
        for verb in range(100):
            if run(prog, noun, verb) == 19690720:
                print(100 * noun + verb)


if __name__  == '__main__':
    main()
