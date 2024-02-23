import time


def progbar(count, itrs):
    print(
        f"Progress: [{'#' * (count // (itrs // 19))}{' ' * (20 - (count // (itrs // 19)))}] {count}/{itrs} holds completed", end="\r")
    if count == itrs:
        print('\a')  # bell to celebrate


def clearprogbar(count, itrs):
    print(' ' * 35, ' ' * itrs, end="\r")


totalholds = 40
compholds = 0

while compholds <= totalholds:
    clearprogbar(compholds, totalholds)
    print('blahblahblahblahblah')
    progbar(compholds, totalholds)
    time.sleep(0.1)
    compholds += 1
