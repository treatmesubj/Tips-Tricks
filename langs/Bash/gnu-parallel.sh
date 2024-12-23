#!/usr/bin/env bash

# man parallel_examples
# man parallel_tutorial
# man parallel

parallel echo "\<{}\>" :::: data.txt  # :::: file
parallel echo "\<{}\>" ::: < data.txt  # ::: stdin
cat data.txt | parallel echo "\<{}\>"
# <you what's up everyone>
# <my name's dave>
# <and you suck at programming>

parallel echo "\<{}\>" ::: multiple input sources ::: with values

# group & print stdout by stdin when jobs are complete
parallel -k traceroute ::: debian.org freenetproject.org

# xargs
mkdir tmp && cd tmp
seq 1 5000 | parallel mkdir test-{}.dir
# mkdir test-1.dir
# mkdir test-2.dir
# mkdir test-3.dir
seq 1 5000 | parallel -X mkdir test-{}.dir
# mkdir test-1.dir test-2.dir test-3.dir
seq 1 5000 | parallel -X rm -rf test-{}.dir


# nested loops
    # (for colour in red green blue ; do
    #   for size in S M L XL XXL ; do
    #     echo $colour $size
    #   done
    # done) | sort
parallel echo {1} {2} ::: red green blue ::: S M L XL XXL | sort
parallel --header : echo {colour} {size} \
  ::: colour red green blue ::: size S M L XL XXL | sort

