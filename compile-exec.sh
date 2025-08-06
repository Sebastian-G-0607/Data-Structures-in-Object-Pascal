#!bin/bash

# Compile and execute a Pascal program
fpc $1
dir=$(dirname $1)
prog=$(basename $1 .pas)
$dir/$prog
rm -f $dir/$prog.o $dir/$prog