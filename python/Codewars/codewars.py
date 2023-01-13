# 8 Kyu
# Code as fast as you can! You need to double the integer and return it.

def double_integer(i):
    return i * 2


# 8 Kyu
# Consider an array/list of sheep where some sheep may be missing from their place.
# We need a function that counts the number of sheep present in the array(true means present).

def count_sheeps(sheep):
    # TODO May the force be with you
    c = 0
    for s in sheep:
        if s:
            c += 1
    return c

# 8 Kyu
# Create a function with two arguments that will return an array of the first n multiples of x.
# Assume both the given number and the number of times to count will be positive numbers greater than 0.
# Return the results as an array or list(depending on language).


def count_by(x, n):
    arr = []
    while 1 <= n:
        arr.append(x*n)
        n -= 1
    res = arr[::-1]
    return res


count_by(1, 100)
