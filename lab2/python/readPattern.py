# 想要查看第幾個pattern
checkpattern = 127

f = open('demo_input.txt', 'r')
text = []
for line in f.readlines():
    text.append(line)

text.remove(text[0])
# print(text)
pattnum = 0
start = False
source = []
destination = []
# print(not(start))
for i in range(len(text)):

    numbers = text[i].split()
    s = int(numbers[0])
    d = int(numbers[1])
    # print(s)
    if (pattnum == checkpattern):  # =========更改此數字以查看特定pattern數
        source.append(s)
        destination.append(d)

    if(s == 16 and (not(start))):
        start = True
        # print("Pattern No. "+str(pattnum))
    elif(s == 16 and d == 16):
        start = False
        pattnum += 1
    # print("Pattern No. "+str(pattnum))


print(source[2:-1])
print(destination[2:-1])

s = source[1]
d = destination[1]
print("起點: "+str(s)+"終點: "+str(d))
