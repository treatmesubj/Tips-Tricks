import math


# you have 2 identical crystal balls
# you need to find the highest floor in building that you can drop one without breaking it
floor_breaks = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1]
step = int(math.sqrt(len(floor_breaks)))
floor_drop = step
while True:
    print(f"floor drop: {floor_drop}")
    ball_status = floor_breaks[floor_drop]
    if ball_status != 1:
        print("not broken")
        if floor_drop == (len(floor_breaks)  - 1):
            print("didn't break on any floor")
            break
        else:
            floor_drop += step
            if floor_drop > (len(floor_breaks)  - 1):
                print("can only go as high as top floor")
                floor_drop = (len(floor_breaks)  - 1)
    else:
        print("first ball broke")
        too_high_floor = floor_drop
        # start from last known safe drop floor + 1
        floor_drop -= (step - 1)
        while True:
            print(f"floor drop: {floor_drop}")
            ball_status = floor_breaks[floor_drop]
            if ball_status != 1:
                print("not broken")
                if floor_drop >= (len(floor_breaks)  - 1):
                    print("didn't break on any floor")
                    break
                else:
                    floor_drop += 1
                    if floor_drop == too_high_floor:
                        print(f"highest floor is {floor_drop - 1}")
                        break
            else:
                print("last ball broke")
                print(f"highest floor is {floor_drop - 1}")
                break
        break

