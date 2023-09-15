import concurrent.futures
import time


def my_func(arg1, arg2):
    print(arg2)
    print(f"Sleeping {arg1} seconds")
    time.sleep(arg1)
    return f"Slept {arg1} seconds"


with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
    arg1_list = [1,2,3,4,5]
    arg2_list = ['wow','nice','cool','neat','sweet']
    # executor.map(my_func, arg1_list, arg2_list)
    results = executor.map(my_func, arg1_list, arg2_list)


print('all done')
for arg1, arg2, res in zip(arg1_list, arg2_list, list(results)):
    print(f"{arg1=}, {arg2=}, {res=}")

