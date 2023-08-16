import random
from random import shuffle,sample
from typing import Dict,List

random.seed(123)
BASE = 10
MAX_BLANK_NUM = 50
NUMBLANK      = 15
# Type hinting
# x = 48
# x = bin(x)
# print(x)

# print(x[2])

# x: int = 3
# y: float = 4.0
# z: float = 5

# h: int = 0
# h = x + y

# print(h)
# This creates a sequence of number
rBase = [num for num in range(BASE)]
print(rBase)

# This kind of pop out the first element of array
a = rBase.pop(0)
print(f"a = {a} , rBase = {rBase}")

# This pops the last element from the array
a = rBase.pop(-1)
print(f"a = {a} , rBase = {rBase}")
# Thus in python, array can easily be used as queue and stack.

# Blanks
# This randomly choose number of blanks(15) number out from the range of 0~50
blanks = sample(range(0,MAX_BLANK_NUM), NUMBLANK)
print(f"blanks = {blanks}")