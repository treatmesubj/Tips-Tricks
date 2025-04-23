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
