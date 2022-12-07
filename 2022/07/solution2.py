import sys


def read_file(l):
    size, name = l.split(' ')
    return int(size), name


def split(input):
    path = []
    p = 0
    while True:
        if p >= len(input):
            break

        l = input[p]
        p += 1
        if l == '$ cd ..':
            path.pop()
        elif l.startswith('$ cd'):
            _, _, dir_name = l.split(' ')
            if dir_name == '/':
                path = []
            else:
                path.append(dir_name)
        else:
            assert(l == '$ ls')
            contents = []
            while True and p < len(input):
                l = input[p]
                if input[p].startswith('$'):
                    break
                if l.startswith('dir'):
                    _, inner_dir_name = l.split(' ')
                    contents.append(('d', '/'.join(path + [inner_dir_name])))
                else:
                    size, file_name = read_file(l)
                    contents.append(('f', file_name, size))
                p += 1
            yield '/'.join(path), contents


def dir_size(d, dirs):
    t = 0
    for e in d:
        if e[0] == 'f':
            t += e[2]
        else:
            t += dir_size(dirs[e[1]], dirs)
    return t


def main():
    input = [l.strip() for l in sys.stdin.readlines()]
    dirs = dict(split(input))

    min_size = 30000000 - (70000000 - dir_size(dirs[''], dirs))
    print(min(size for size in
              (dir_size(d, dirs) for d in dirs.values())
              if size >= min_size))


if __name__ == '__main__':
    main()
