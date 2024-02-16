#!/usr/bin/env python

def fizzbuzz(itr):
    # % modulo returns signed remainder of division
    for num in itr:
        if (num % 3) == 0:
            print('fizz')
        if (num % 5) == 0:
            print('buzz')
        else:
            print('num')


def fizz_buzz(itr):
    # truthiness regarding 0: for int data-type, 0 is False - any other int is True
    for num in itr:
        print("Fizz" * (not num % 3) + "Buzz" * (not num % 5) or num)
