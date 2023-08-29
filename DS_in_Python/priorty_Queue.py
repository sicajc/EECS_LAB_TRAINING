from queue import PriorityQueue

# Example 1
q = PriorityQueue()

q.put(4)
q.put(2)
q.put(5)
q.put(1)
q.put(3)

while not q.empty():
    next_item = q.get()
    print(next_item)

q = PriorityQueue(maxsize=3)

# Can first declare the variables for priority of each item in order, then
# Throw there items into the priority queue.
# (priority_number, data)'s tuple
VIP = 0
NORMAL = 1

q.put((VIP,'VIP', 'Read'))
q.put((VIP,'VIP', 'Play'))
q.put((NORMAL,'NORMAL', 'Write'))
q.put((NORMAL,'NORMAL', 'Code'))
q.put((NORMAL,'NORMAL', 'Study'))

while not q.empty():
    next_item = q.get()
    print(next_item)
