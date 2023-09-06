def print_sudoku(board):
    for i in range(len(board)):
        if i % 3 == 0 and i != 0:
            print("-" * 21)
        for j in range(len(board[i])):
            if j % 3 == 0 and j != 0:
                print("|", end=" ")
            print(board[i][j], end=" ")
        print()

def is_valid(board, row, col, num):
    # Check if 'num' is already in the current row or column
    for i in range(9):
        if board[row][i] == num or board[i][col] == num:
            return False

    # Check if 'num' is already in the current 3x3 subgrid
    start_row, start_col = 3 * (row // 3), 3 * (col // 3)
    for i in range(start_row, start_row + 3):
        for j in range(start_col, start_col + 3):
            if board[i][j] == num:
                return False

    return True

def solve_sudoku(board):
    stack = []

    for row in range(9):
        for col in range(9):
            if board[row][col] == 0:
                stack.append((row, col))

    # Stack here grows downwards.
    index = 0

    while index < len(stack):
        row, col = stack[index]
        found = False

        for num in range(board[row][col] + 1, 10):
            if is_valid(board, row, col, num):
                board[row][col] = num
                found = True
                break

        if found:
            index += 1
        else:
            board[row][col] = 0
            index -= 1
            if index < 0:
                return False  # No solution exists

    return True

# Example Sudoku board (0 represents empty cells)
sudoku_board = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9]
]

if solve_sudoku(sudoku_board):
    print("Solved Sudoku:")
    for row in sudoku_board:
        print(row)
else:
    print("No solution exists.")
