from typing import Sequence
import collections

# from collections.deque


def simple_tail(seq, num):
    return seq[-num:]


def tail(seq: Sequence, num: int):
    """
    seq: sequence
    num: integer
    return: list of last n elements of a sequence
    """
    assert isinstance(seq, collections.abc.Sequence) is True, "seq not type sequence"
    assert isinstance(num, int) is True, "num not type int"

    return seq[-num:]


def dumb_tail(seq, num):
    length = len(seq)
    last_n_elems = []
    idx = 0
    for i in seq:
        if idx >= (length - num):
            last_n_elems.append(i)
        idx += 1
    return last_n_elems


lamb_tail = lambda seq, num: seq[-num:]


if __name__ == "__main__":
    import timeit

    print(
        "simple_tail: ",
        timeit.timeit("simple_tail(('a','b','c','d','e'), 3)", globals=locals()),
    )
    print("tail: ", timeit.timeit("tail(('a','b','c','d','e'), 3)", globals=locals()))
    print(
        "dumb_tail: ",
        timeit.timeit("dumb_tail(('a','b','c','d','e'), 3)", globals=locals()),
    )
    print(
        "lamb_tail: ",
        timeit.timeit("lamb_tail(('a','b','c','d','e'), 3)", globals=locals()),
    )
