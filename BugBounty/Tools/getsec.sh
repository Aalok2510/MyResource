#!/bin/bash
shopt -s expand_aliases
alias httpx=/home/hack2death/Tools/./httpx
alias secretfinder='python3 /home/hack2death/Tools/secretfinder/SecretFinder.py -e -o cli -i'
dir=/home/hack2death/Recon/$1
v=$(echo $1 | httpx) 
secretfinder $v  >  $dir/$1_secretfinder.txt;
 




