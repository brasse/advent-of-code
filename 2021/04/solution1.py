import sys


def main():
    lines = sys.stdin.readlines()
    numbers = [int(x) for x in lines[0].split(',')]
    boards = get_boards(lines[1:])
    index = {}
    for (i, board) in enumerate(boards):
        index_board(board, i, index)

    def play():
        for n in numbers:
            for (i, x, y) in index[n]:
                board = boards[i]
                board[x + y * 5] = None
                if is_win(col(board, x)) or is_win(row(board, y)):
                    return (n, board)

    (winning_number, winning_board) = play()
    print(winning_number * sum(x for x in winning_board if x is not None))


def get_boards(lines):
    def row(r):
        return [int(x) for x in lines[r].split()]

    def _get_boards():
        for x in range(len(lines) // 6):
            yield (row(x * 6 + 1) + row(x * 6 + 2) + row(x * 6 + 3)
                   + row(x * 6 + 4) + row(x * 6 + 5))
    return list(_get_boards())


def index_board(board, i, index):
    for y in range(5):
        for x in range(5):
            n = board[y * 5 + x]
            l = index.get(n, [])
            l.append((i, x, y))
            index[n] = l


def is_win(l):
    return len([x for x in l if x is None]) == 5


def row(board, n):
    return board[n * 5:n * 5 + 5]


def col(board, n):
    def _col():
        for r in range(5):
            yield board[r * 5 + n]
    return list(_col())


if __name__ == '__main__':
    main()
