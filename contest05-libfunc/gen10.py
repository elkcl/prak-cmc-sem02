from random import randint, choice

q = randint(0, 10)
for _ in range(q):
    c = choice(('A', 'D', 'S'))
    if c == 'A':
        print("A {} {}".format(randint(-10, 10), randint(-10, 10)))
    elif c == 'D':
        print("D {}".format(randint(-10, 10)))
    else:
        print("S {}".format(randint(-10, 10)))
print('F')
