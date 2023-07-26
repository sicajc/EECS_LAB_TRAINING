import random
import copy
MAZE_SIZE = 17
NUM_OF_MAZE = 250

def dfs_recursive(src,maze,visited):
    y,x = src

    # Mark this node as visited
    visited[y][x] = 1

    # Direction
    directions = ['north','south','east','west']
    # Random shuffle the directions
    random.shuffle(directions)
    # From the current node, start traversing all the possible neighbors
    for dir in directions:
        if(dir == 'north'):
            # If it has not been traversed yet, visit it
            if(visited[y-2][x] == 0):
                # Break the wall
                maze[y-1][x] = 1
                src = (y-2,x)
                # Recursive call
                dfs_recursive(src,maze,visited)

        elif(dir == 'south'):
            # Check if traversed or traversable?
            # print("y = ",y, "x = ",x)
            if(visited[y+2][x] == 0):
                # Break the wall
                maze[y+1][x] = 1
                src = (y+2,x)
                # Recursive call
                dfs_recursive(src,maze,visited)

        elif(dir == 'east'):
            # Check if traversed or traversable?
            if(visited[y][x+2] == 0):
                # Break the wall
                maze[y][x+1] = 1
                src = (y,x+2)
                # Recursive call
                dfs_recursive(src,maze,visited)

        elif(dir == 'west'):
            # Check if traversed or traversable?
            if(visited[y][x-2] == 0):
                # Break the wall
                maze[y][x-1] = 1
                src = (y,x-2)
                # Recursive call
                dfs_recursive(src,maze,visited)

def maze_generator():
    src = (2,2)
    # Create maze
    # The size of maze must be odd!
    maze = [[1 for i in range(MAZE_SIZE)] for j in range(MAZE_SIZE)]
    visited = [[0 for i in range(MAZE_SIZE)] for j in range(MAZE_SIZE)]
    maze_padded = [[0 for i in range(MAZE_SIZE+4)] for j in range(MAZE_SIZE+4)]
    visited_padded = [[0 for i in range(MAZE_SIZE+4)] for j in range(MAZE_SIZE+4)]

    # Generate odd-even walls in maze
    for i in range(MAZE_SIZE):
        for j in range(MAZE_SIZE):
            for k in range(MAZE_SIZE):
                if i == (1+2*k) or j == (1+2*k):
                    maze[i][j] = 0
                    visited[i][j] = 1


    # Put it into the padded maze to handle boundary condition
    for i in range(MAZE_SIZE):
        for j in range(MAZE_SIZE):
            maze_padded[i+2][j+2] = maze[i][j]
            visited_padded[i+2][j+2] = visited[i][j]


    # Mark the boundaries as visited and mark walls as visited
    for i in range(MAZE_SIZE+4):
        for j in range(MAZE_SIZE+4):
            if i == 0 or i == MAZE_SIZE+2 or j == 0 or j == MAZE_SIZE+2:
                visited_padded[i][j] = 1
            if i == 1 or j == 1 or i == MAZE_SIZE+3 or j == MAZE_SIZE+3:
                visited_padded[i][j] = 1

    # Run DFS on maze
    dfs_recursive(src,maze_padded,visited_padded)

    # Extract the maze out
    for i in range(2,MAZE_SIZE+2):
        for j in range(2,MAZE_SIZE+2):
            maze[i-2][j-2] = maze_padded[i][j]

    return maze

def thereIsDeadend(maze_padded):
    for y in range(1,MAZE_SIZE+1):
        for x in range(1,MAZE_SIZE+1):
            cnt = 0

            # Try all directions
            if(maze_padded[y-1][x] == 0):
                # north
                cnt = cnt + 1
            if(maze_padded[y+1][x] == 0):
                # south
                cnt = cnt + 1
            if(maze_padded[y][x+1] == 0):
                # east
                cnt = cnt + 1
            if(maze_padded[y][x-1] == 0):
                # west
                cnt = cnt + 1

            if cnt == 3 and maze_padded[y][x] != 0:
                if not (x == 1 and y == 1):
                    if not (x==MAZE_SIZE and y == MAZE_SIZE):
                        return True


    return False

def isJunction(maze,y,x):
    cnt = 0
    # If not src or dst
    if x == 1 and y == 1:
        return False

    if x == MAZE_SIZE and y == MAZE_SIZE:
        return False

    if maze[y][x] == 1:
        # Try all directions
        if(maze[y-1][x] == 1):
            # north
            cnt = cnt + 1
        if(maze[y+1][x] == 1):
            # south
            cnt = cnt + 1
        if(maze[y][x+1] == 1):
            # east
            cnt = cnt + 1
        if(maze[y][x-1] == 1):
            # west
            cnt = cnt + 1

    if cnt >= 3:
        return True

    return False

def wallPadding(maze):
    maze_padded = [[0 for i in range(MAZE_SIZE+2)] for j in range(MAZE_SIZE+2)]

    # print("------------------------MAZE------------------------")
    # print(maze)

    for i in range(MAZE_SIZE):
        for j in range(MAZE_SIZE):
                maze_padded[i+1][j+1] = maze[i][j]

    return maze_padded

def SearchDeadEndsMarkJunctions(maze_padded):
    deadends = []

    # Search for dead ends and junctions
    for y in range(1,MAZE_SIZE+1):
        for x in range(1,MAZE_SIZE+1):
            cnt = 0

            # Try all directions
            if(maze_padded[y-1][x] == 0):
                # north
                cnt = cnt + 1
            if(maze_padded[y+1][x] == 0):
                # south
                cnt = cnt + 1
            if(maze_padded[y][x+1] == 0):
                # east
                cnt = cnt + 1
            if(maze_padded[y][x-1] == 0):
                # west
                cnt = cnt + 1

            if cnt == 3 and maze_padded[y][x] != 0:
                if not (x == 1 and y == 1):
                    if not (x==MAZE_SIZE and y == MAZE_SIZE):
                        # maze_padded[y][x] = 7
                        deadends.append([y,x])

            if isJunction(maze_padded,y,x) == True:
                maze_padded[y][x] = 2

    return deadends


def fillDeadEnds(maze_padded,deadends):
    for deadend in deadends:
      y = deadend[0]
      x = deadend[1]

      while maze_padded[y][x] != 2:
         if y == 1 and x == 1:
             break
         if y == MAZE_SIZE and x == MAZE_SIZE:
             break

         # Fill the current node
         maze_padded[y][x] = 0
         # Try all directions
         if(maze_padded[y-1][x] == 1 or maze_padded[y-1][x] == 2):
             # north
             y = y-1
             x = x
         elif(maze_padded[y+1][x] == 1 or maze_padded[y+1][x] == 2):
             # south
             y = y+1
             x = x
         elif(maze_padded[y][x+1] == 1 or maze_padded[y][x+1] == 2):
             # east
             y = y
             x = x+1
         elif(maze_padded[y][x-1] == 1 or maze_padded[y][x-1] == 2):
             # west
             y = y
             x = x-1

    # Remove all the junctions
    for y in range(1,MAZE_SIZE+1):
        for x in range(1,MAZE_SIZE+1):
            if maze_padded[y][x] == 2:
                maze_padded[y][x] = 1

    return maze_padded

def maze_solver(maze):
    # Give maze, return a path from src to dst
    maze_padded = wallPadding(maze)

    # Perform dead end filling algorithm until there is no more deadends
    while thereIsDeadend(maze_padded) == True:
        deadends = SearchDeadEndsMarkJunctions(maze_padded)
        maze_padded = fillDeadEnds(maze_padded, deadends)

    # Walk the path and record the directions
    path = []

    y = 1
    x = 1

    while True:
        maze_padded[y][x] = "x"

        if y == MAZE_SIZE and x == MAZE_SIZE:
            break

        # Try all directions
        if(maze_padded[y-1][x] == 1):
            # north
            y = y-1
            x = x
            path.append(3)
        elif(maze_padded[y+1][x] == 1):
            # south
            y = y+1
            x = x
            path.append(1)
        elif(maze_padded[y][x+1] == 1):
            # east
            y = y
            x = x+1
            path.append(0)
        elif(maze_padded[y][x-1] == 1):
            # west
            y = y
            x = x-1
            path.append(2)

    return path,maze_padded



file_input  = open("./pattern/input.txt","w")
file_output = open("./pattern/output.txt","w")
file_maze_result = open("./pattern/maze_result.txt","w")

file_input.write(  "NUM_OF_PAT: "+ str(NUM_OF_MAZE) + "\n\n")
file_output.write(  "NUM_OF_PAT: "+ str(NUM_OF_MAZE) + "\n\n")
file_maze_result.write(  "NUM_OF_PAT: "+ str(NUM_OF_MAZE) + "\n\n")



for idx in range(NUM_OF_MAZE):
    maze = copy.deepcopy(maze_generator())

    file_input.write("PATTERN NO: " + str(idx) + "\n")
    file_output.write("PATTERN NO: " + str(idx) + "\n")
    file_maze_result.write("PATTERN NO: " + str(idx) + "\n")

    # Write into input file
    for i in range(MAZE_SIZE):
        for j in range(MAZE_SIZE):
            file_input.write(str(maze[i][j]))
            file_input.write(" ")

        file_input.write("\n")

    file_input.write("\n")

    golden_path,maze_traced = maze_solver(maze)

    for dir in golden_path:
        file_output.write(str(dir))
        file_output.write(" ")

    file_output.write("\n\n")

    # Write into maze result
    for i in range(MAZE_SIZE+2):
        for j in range(MAZE_SIZE+2):
            file_maze_result.write(str(maze_traced[i][j]))
            file_maze_result.write(" ")

        file_maze_result.write("\n")

    file_maze_result.write("\n")
