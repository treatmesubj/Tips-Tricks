#!/usr/bin/env bash

s='far'

# ;; match & execute, then esac
case "$s" in
    d*) echo 'matched d*';;
    dave) echo 'matched dave';;
    f*) echo 'matched f*';;
    foo) echo 'matched foo';;
    *) echo 'matched *';;
esac

# ;;& match & execute, and continue to next case
case "$s" in
    d*) echo 'matched d*';;&
    dave) echo 'matched dave';;&
    f*) echo 'matched f*';;&
    foo) echo 'matched foo';;&
    *) echo 'matched *';;&
esac

# ;& match & execute, treat next case as a match (even if it isn't) & execute
case "$s" in
    d*) echo 'matched d*';&
    dave) echo 'matched dave';&
    f*) echo 'matched f*';&
    foo) echo 'matched foo';&
    *) echo 'matched *';&
esac
