

def factorial(num):
    assert num >= 1

    if num == 1:
        return 1
    else:
        return num * factorial(num -1)


if __name__ == "__main__":
    print("5!")
    print(factorial(5))
