

def factorial(num):
    assert num >= 1
    if num == 1:
        print("---")
        return 1
    else:
        print(f"... {num} * {num - 1}!")
        return num * factorial(num -1)


if __name__ == "__main__":
    print("5!")
    print(factorial(5))
