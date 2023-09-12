"""
Given a string s, find the length of the longest
substring
without repeating characters.
"""


class Solution(object):
    def lengthOfLongestSubstring(self, stringy):
        substr_lens = (0,)
        substr = ""
        for char in stringy:
            count = len(substr)
            print(f"{substr_lens=}, {substr=}, {count=}; next {char=}")
            if char not in substr:
                substr += char
            else:
                substr_lens += (count,)
                substr = substr[substr.index(char)+1:] + char
        substr_lens += (len(substr),)
        print(f"final: {substr_lens=}, {substr=}\n--------")
        return max(substr_lens)


if __name__ == "__main__":
    x = Solution
    print(x.lengthOfLongestSubstring(x, 'bbbbb'))
    print(x.lengthOfLongestSubstring(x, 'aab'))
    print(x.lengthOfLongestSubstring(x, 'abcbb'))
    print(x.lengthOfLongestSubstring(x, 'jgdahlk'))
    print(x.lengthOfLongestSubstring(x, 'aaaahlk'))
    print(x.lengthOfLongestSubstring(x, 'pwwkew'))
    print(x.lengthOfLongestSubstring(x, ''))
    print(x.lengthOfLongestSubstring(x, 'aa'))
    print(x.lengthOfLongestSubstring(x, 'a'))
    print(x.lengthOfLongestSubstring(x, 'dvdf'))
    print(x.lengthOfLongestSubstring(x, 'dvdf'))
