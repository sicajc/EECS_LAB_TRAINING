def pad_maze(maze):
    # Find the dimensions of the original maze
    height = len(maze)
    width = len(maze[0])

    # Create a new maze with padding (zeros)
    padded_maze = [[0] * (width + 2) for _ in range(height + 2)]

    # Copy the original maze into the center of the padded maze
    for i in range(height):
        for j in range(width):
            padded_maze[i + 1][j + 1] = maze[i][j]

    return padded_maze

def solve_maze(maze):
    # Define directions: right, down, left, up
    directions = [(0, 1), (1, 0), (0, -1), (-1, 0)]

    def is_valid(x, y):
        return 0 <= x < len(maze) and 0 <= y < len(maze[0]) and maze[x][y] == 1

    def has_unvisited_neighbors(x, y):
        return any(maze[x + dx][y + dy] == 0 for dx, dy in directions)

    def mark_visited(x, y):
        maze[x][y] = 2

    def backtrack(x, y):
        maze[x][y] = 3

    # Find the dimensions of the maze with padding
    height = len(maze)
    width = len(maze[0])

    # Initialize the start and end points
    start_x, start_y = 1, 1
    end_x, end_y = height - 2, width - 2

    while (start_x, start_y) != (end_x, end_y):
        if has_unvisited_neighbors(start_x, start_y):
            # Move forward to an unvisited cell
            for dx, dy in directions:
                new_x, new_y = start_x + dx, start_y + dy
                if is_valid(new_x, new_y):
                    mark_visited(start_x, start_y)
                    start_x, start_y = new_x, new_y
                    break
        else:
            # Mark dead-end and backtrack
            backtrack(start_x, start_y)
            for dx, dy in directions:
                new_x, new_y = start_x - dx, start_y - dy
                if maze[new_x][new_y] == 2:
                    start_x, start_y = new_x, new_y
                    break

    # Mark the exit as part of the solution path
    maze[end_x][end_y] = 3

    # Remove the padding from the solved maze
    solved_maze = [row[1:-1] for row in maze[1:-1]]

    return solved_maze

# Example maze (0 represents walls, 1 represents passages)
maze = [
    [0, 0, 0, 0, 0],
    [1, 1, 0, 1, 0],
    [0, 0, 0, 1, 0],
    [0, 1, 1, 1, 1],
    [0, 0, 0, 0, 0]
]

# Pad the maze and solve it
padded_maze = pad_maze(maze)
solved_maze = solve_maze(padded_maze)

# Display the solved maze (2 represents visited cells, 3 represents the solution path)
for row in solved_maze:
    print(row)
