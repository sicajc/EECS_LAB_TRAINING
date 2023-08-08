NUM_OF_INPUTS = 64
for i in range(NUM_OF_INPUTS):
    # print(f"c{i}",end=" ")

    # print(f"Mn{i} result c{i} GND x nmos_lvt  m=1")
    #                   D      G   S  X

    # if i == 0:
    #     print(f"Mp{i}  n{i}  c{i}  VDD   x pmos_lvt  m=1")
    # elif i == 63:
    #     print(f"Mp{i} result c{i} n{i-1} x pmos_lvt  m=1")
    # else:
    #     print(f"Mp{i}  n{i}  c{i} n{i-1} x pmos_lvt  m=1")
    print(f"XoneBitCompBuf{i} a{i} b{i} c{i} oneBitCompBuf")
