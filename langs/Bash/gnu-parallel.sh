#!/usr/bin/env bash

# man parallel_examples
# man parallel_tutorial
# man parallel

parallel echo "\<{}\>" :::: data.txt  # :::: file
parallel echo "\<{}\>" :::: <(cat data.txt)  # :::: file; <(...) is path to file descriptor e.g. "/dev/fd/63"
parallel echo "\<{}\>" ::: "$shirtsizes" ::: "$shirtcolors" # :::: variables
parallel echo "\<{}\>" ::: < data.txt # ::: stdin
cat data.txt | parallel echo "\<{}\>"
# <yo what's up everyone>
# <my name's dave>
# <and you suck at programming>

parallel echo "\<{}\>" ::: multiple input sources ::: with values
parallel echo "\<{1}\>" "\<{2}\>" ::: multiple input sources ::: with values
# similar via brace expansion
array=({multiple,input,sources}" "{with,values})
for item in "${array[@]}"; do
    echo "<$item>"
done

# double grep
parallel rg -il findduplicate :::: <(rg -il addsurrogatekey) | wc -l

# quoting
parallel rg -iH '"'pipeline: '{1}" -A 1 {2}' ::: "$dag_files" ::: "$raps_pipelines"

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


# nested loops, cross joining, etc.
    (for colour in red green blue ; do
      for size in S M L XL XXL ; do
        echo $colour $size
      done
    done) | sort
parallel echo {1} {2} ::: red green blue ::: S M L XL XXL | sort
parallel --header : echo {colour} {size} \
  ::: colour red green blue ::: size S M L XL XXL | sort
