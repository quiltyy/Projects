# Question 4
# Write a program which accepts a sequence of comma-separated numbers from console and generate
# a list and a tuple which contains every number.Suppose the following input is supplied to the program:

from cmath import sqrt
import math
lst = input('Insert a list numbers seperated by a commas: ').split(',')
tpl = tuple(lst)
print(lst)
print(tpl)

# Question 5
# Define a class which has at least two methods:
# getString: to get a string from console input
# printString: to print the string in upper case.
# Also please include simple test function to test the class methods.


class string_class(object):
    def get_string(self):
        self.s = input("Insert String: ")

    def print_string(self):
        print(self.s.upper())


xx = string_class()
xx.get_string()
xx.print_string()

# Question 6
# # Write a program that calculates and prints the value according to the given formula:
# Q = Square root of[(2 _ C _ D)/H]
# Following are the fixed values of C and H:
# C is 50. H is 30.
# D is the variable whose values should be input to your program in a comma-separated sequence.
# For example Let us assume the following comma separated input sequence is given to the program:

C = 50
H = 30


def calc(D):
    return sqrt((2*C*D)/H)


# splits in comma position and set up in list
D = [int(i) for i in input().split(',')]
D = [int(i) for i in D]   # converts string to integer
# retruns floating value by clac method for every item in D
D = [calc(i) for i in D]
D = [round(i) for i in D]  # type: ignore # All the floating values are rounded
# All the integers are converted to string to be able to apply join operation
D = [str(i) for i in D]

print(",".join(D))

# Question 7
# Write a program which takes 2 digits, X,Y as input and generates a 2-dimensional array.
# The element value in the i-th row and j-th column of the array should be i _ j.*
# Note: i = 0, 1.., X-1 # j = 0, 1, ¡­Y-1.

x, y = map(int, input().split(','))
lst = []

for i in range(x):
    tmp = []
    for j in range(y):
        tmp.append(i*j)
    lst.append(tmp)

print(lst)


# Question 8
# Write a program that accepts a comma separated sequence of words as input and
# prints the words in a comma-separated sequence after sorting them alphabetically.

lst = input().split(',')
lst.sort()
print(",".join(lst))

# Question 9
# Write a program that accepts sequence of lines as input and
# prints the lines after making all characters in the sentence capitalized.

lst = []

while True:
    x = input()
    if len(x) == 0:
        break
    lst.append(x.upper())

for line in lst:
    print(line)
