from queue import Queue

q = Queue(maxsize=3)

data = [3,2,1,99,2,3,4,5]

while not q.full():
    q.put(data.pop(0)) # This means poping data starting from idx 0

print(f"Current queue has value: {list(q.queue)}")

list1 = ['a', 'b', 'c', 'd']
list2 = []
for i in range(4):
    if list1[i] == 'c':
        continue
    else:
        list2.append(list1[i])


#