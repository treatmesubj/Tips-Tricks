#!/usr/bin/env python3
def get_user_input():
    return input("hey: ")


# ===== Don't write this =====
response = get_user_input()
if response:
    print('You pressed:', response)
else:
    print('You pressed nothing')

# ===== Write this instead =====
# walrus operator assigns value if it's not None
if response := get_user_input():
    print('You pressed:', response)
else:
    print('You pressed nothing')

# one line conditional string concatenation
dicty = {"a": 1, "b": 2, "c": None, "d": 4}
stringy = ", ".join(
    guy + (f" is {str(v)}" if (v := dicty.get(guy)) else " isn't")
    for guy in ["a", "b", "c", "d", "e"]
)
print(stringy)
