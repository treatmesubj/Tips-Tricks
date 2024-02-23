import concurrent.futures
import time


def my_func(arg1: int, arg2: int) -> int:
    print(arg2)
    print(f"Sleeping {arg1} seconds")
    time.sleep(arg1)
    return f"Slept {arg1} seconds"


def add_it(num1: int, num2: int) -> int:
    res = num1 + num2
    print(f"add_it result: {res}")
    return res


with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
    arg1_list = [1,2,3,4,5]
    arg2_list = ['wow','nice','cool','neat','sweet']
    # executor.map(my_func, arg1_list, arg2_list)
    results1 = executor.map(my_func, arg1_list, arg2_list)

    arg3_list = [6,7,8]
    arg4_list = ['oh', 'sure', 'ok']
    results2 = executor.map(my_func, arg3_list, arg4_list)

    result3 = executor.submit(add_it, 1, 2)


print('all done')
for arg1, arg2, res in zip(arg1_list, arg2_list, list(results1)):
    print(f"{arg1=}, {arg2=}, {res=}")

for arg3, arg4, res in zip(arg3_list, arg4_list, list(results2)):
    print(f"{arg3=}, {arg4=}, {res=}")

print(f"result3: {result3.result()}")

