#!/usr/bin/env python3

import sys


def points2lin(x1, x2, y1, y2):
    a = (y2 - y1) / (x2 - x1)
    b = y1 - a * x1
    return a, b


def lin(a, b, x):
    return a * x + b


def plot_x(points, X, under_t, over_t):
    it = iter(points)
    x1, y1 = it.__next__()

    if X < x1:
        return under_t

    for x2, y2 in it:
        if x1 <= X <= x2:
            a, b = points2lin(x1, x2, y1, y2)
            return lin(a, b, X)

        x1, y1 = x2, y2
    return over_t


def main():
    curr_temp = float(sys.argv[1])

    points = list()
    it = iter(list(sys.argv[2:]))

    while True:
        try:
            x = float(it.__next__())
            y = float(it.__next__())
        except:
            break

        points.append((x, y))

    print(int(plot_x(points, curr_temp, 0, 100)))


if __name__ == '__main__':
    main()
