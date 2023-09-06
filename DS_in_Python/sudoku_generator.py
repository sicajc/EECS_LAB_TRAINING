import random
import math

def is_valid_move(board, row, col, num):
    # Check if 'num' is already in the current row or column
    for i in range(len(board)):
        if board[row][i] == num or board[i][col] == num:
            return False

    # Check if 'num' is already in the current subgrid
    subgrid_size = int(math.sqrt(len(board)))
    start_row, start_col = subgrid_size * (row // subgrid_size), subgrid_size * (col // subgrid_size)
    for i in range(start_row, start_row + subgrid_size):
        for j in range(start_col, start_col + subgrid_size):
            if board[i][j] == num:
                return False

    return True

def solve_sudoku(board):
    empty_cell = find_empty_cell(board)
    if not empty_cell:
        return True  # No empty cells, puzzle is solved
    row, col = empty_cell

    for num in range(1, len(board) + 1):
        if is_valid_move(board, row, col, num):
            board[row][col] = num

            if solve_sudoku(board):
                return True

            board[row][col] = 0  # Backtrack if no solution found

    return False

def find_empty_cell(board):
    for i in range(len(board)):
        for j in range(len(board)):
            if board[i][j] == 0:
                return (i, j)
    return None

def is_perfect_square(n):
    sqrt_n = int(math.sqrt(n))
    return sqrt_n * sqrt_n == n

def generate_sudoku(size):
    if not is_perfect_square(size):
        print("Size must be a perfect square (e.g., 4, 9, 16, ...)")
        return None

    board = [[0] * size for _ in range(size)]
    solve_sudoku(board)  # Generate a solved Sudoku puzzle

    # Remove some numbers to create the puzzle
    empty_cells = size * size // 2  # Adjust this value to control puzzle difficulty
    while empty_cells > 0:
        row, col = random.randint(0, size - 1), random.randint(0, size - 1)
        if board[row][col] != 0:
            board[row][col] = 0
            empty_cells -= 1

    return board

def print_sudoku(board):
    for row in board:
        print(row)

# Example: Generate and print a 9x9 Sudoku puzzle
size = 9
sudoku_puzzle = generate_sudoku(size)
print_sudoku(sudoku_puzzle)
