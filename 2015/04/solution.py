import sys
from hashlib import md5


def solve(key, n):
    i = 1
    while True:
        s = key + str(i)
        if md5(s.encode()).hexdigest()[:n] == '0' * n:
            break
        i += 1
    return i

def main():
    key = sys.stdin.read().strip()
    print('1:', solve(key, 5))
    print('2:', solve(key, 6))


if __name__ == '__main__':
    main()
