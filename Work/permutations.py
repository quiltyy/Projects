from itertools import permutations

perm = permutations(['FA', 'MO', 'UNK'], 2)

for i in list(perm):
    print(i)