import math
NUM_OF_INPUTS = 64
STAGES = 6
stage = [32,16,8,4,2,1]
for j in range(STAGES):
    print(f"**Stages:{j}**")
    cnt = 1
    for i in range(0,stage[j]):

        # print(f"XoneBitCompBuf{i} a{i} b{i} c{i} oneBitCompBuf")
        if j == 0:
            print(f"Xand2_{j}_{i} c{i*2} c{i*2+1} s_{j}_{i} and2")
        else:
            print(f"Xand2_{j}_{i} s_{j-1}_{i*2} s_{j-1}_{i*2+1} s_{j}_{i} and2")

        # print(f"c{i}",end=" ")

        # print(f"Mn{i} result c{i} GND x nmos_lvt  m=1")
        #                   D      G   S  X

        # if i == 0:
        #     print(f"Mp{i}  n{i}  c{i}  VDD   x pmos_lvt  m=1")
        # elif i == 63:
        #     print(f"Mp{i} result c{i} n{i-1} x pmos_lvt  m=1")
        # else:
        #     print(f"Mp{i}  n{i}  c{i} n{i-1} x pmos_lvt  m=1")