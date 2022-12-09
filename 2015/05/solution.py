import sys


def vowels(s):
    return sum(1 for c in s if c in 'aeiou')


def twice(s):
    return any(s[i] == s[i + 1] for i in range(len(s) - 1))


def forbidden(s:str):
    baddies = ['ab', 'cd', 'pq', 'xy']
    return any(bad in s for bad in baddies)


def repeat(s):
    for i in range(len(s) - 3):
        head = s[i:i + 2]
        tail = s[i + 2:]
        if head in tail:
            return True
    return False


def spase_twice(s):
    return any(s[i] == s[i + 2] for i in range(len(s) - 2))


def nice(s):
    return vowels(s) > 2 and twice(s) and not forbidden(s)


def nice2(s):
    return repeat(s) and spase_twice(s)


def main():

    input = [l.strip() for l in sys.stdin.readlines()]

    print('1:', sum(1 if nice(s) else 0 for s in input))
    print('2:', sum(1 if nice2(s) else 0 for s in input))


if __name__ == '__main__':
    main()
