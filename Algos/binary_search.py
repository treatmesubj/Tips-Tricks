import time


# find a num in sorted ascending array of nums
# binary search: look to mid; is num > mid or num < mid or num == mid?
# log n
def binary_search(sorted_array, target_val):
    low_index = 0
    high_index = len(sorted_array) - 1

    while low_index <= high_index:
        print("-" * 20)
        print(sorted_array)
        print(sorted_array[low_index : high_index + 1])
        print(f"low index: {low_index}, high index: {high_index}")

        mid_index = (low_index + high_index) // 2
        print(f"mid index: {mid_index}")

        if target_val == sorted_array[mid_index]:
            print(f"winner: {mid_index}")
            return mid_index

        elif target_val < sorted_array[mid_index]:
            time.sleep(1)
            high_index = mid_index - 1

        else:
            assert target_val > sorted_array[mid_index]
            time.sleep(1)
            low_index = mid_index + 1

    print("loser")
    return False


if __name__ == "__main__":
    binary_search([1, 3, 4, 7, 12, 14, 16, 19, 22, 23, 27], 16)
