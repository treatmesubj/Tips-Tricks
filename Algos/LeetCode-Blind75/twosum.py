"""
Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

You can return the answer in any order.
"""


class Solution(object):
    def twoSum(self, nums, target):
        dicty = {}
        for idx, num in enumerate(nums):
            remainder = target - num
            if remainder in dicty.keys():
                return [idx, dicty[remainder]]
            else:
                dicty[num] = idx
        return dicty

