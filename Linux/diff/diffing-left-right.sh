# plain different lines
diff <(echo -e "a\nb\nc\nd") <(echo -e "b\nc\nd\ne") \
    --old-line-format='%L' \
    --new-line-format='%L' \
    --unchanged-line-format=''

# in left, but not right
diff <(echo -e "a\nb\nc\nd") <(echo -e "b\nc\nd\ne") \
    --old-line-format='%L' \
    --new-line-format='' \
    --unchanged-line-format=''

# in right, but not left
diff <(echo -e "a\nb\nc\nd") <(echo -e "b\nc\nd\ne") \
    --old-line-format='' \
    --new-line-format='%L' \
    --unchanged-line-format=''
