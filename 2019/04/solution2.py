import sys

def not_decreasing(password):
    last = '0'
    for c in str(password):
        if c < last:
            return False
        last = c
    return True

def longest_seq(password, digit):
    s = str(password)
    for i in reversed(range(1, len(s) + 1)):
        if str(digit)*i in s:
            return i
    return 0

def has_double(password):
    return 2 in [longest_seq(password, i) for i in range(10)]

def passwords(lower, upper):
    for password in range(lower, upper + 1):
        if not_decreasing(password) and has_double(password):
            yield password

def main():
    lower, upper = (int(x) for x in sys.stdin.readline().split('-'))
    print(len(list(passwords(lower, upper))))

if __name__  == '__main__':
    main()
