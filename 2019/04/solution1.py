import sys

def not_decreasing(password):
    last = '0'
    for c in str(password):
        if c < last:
            return False
        last = c
    return True

def has_double(password):
    s = str(password)
    for i in range(10):
        if str(i)*2 in s:
            return True
    return False

def passwords(lower, upper):
    for password in range(lower, upper + 1):
        if not_decreasing(password) and has_double(password):
            yield password

def main():
    lower, upper = (int(x) for x in sys.stdin.readline().split('-'))
    print(len(list(passwords(lower, upper))))

if __name__  == '__main__':
    main()
