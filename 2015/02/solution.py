import sys

def parse_box(l):
    l, w, h = l.split('x')
    return int(l), int(w), int(h)


def paper(b):
    l, w, h = b
    s1 = l * w
    s2 = w * h
    s3 = h * l
    return 2 * (s1 + s2 + s3) + min(s1, s2, s3)


def ribbon(b):
    l, w, h = b
    return 2 * min(l + w, w + h, h + l)


def bow(b):
    l, w, h = b
    return l * w * h

    
def main():
    boxes = [parse_box(l) for l in sys.stdin.readlines()]

    print('1:', sum(paper(b) for b in boxes))
    print('2:', sum(ribbon(b) + bow(b) for b in boxes))


if __name__ == '__main__':
    main()
