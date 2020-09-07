#!/bin/bash
shopt -s expand_aliases
alias httprobe=/home/hack2death/go/bin/./httprobe
dir=/home/hack2death/Recon/$1
v=$(echo $1 | httprobe -prefer-https) 
python3 /home/hack2death/Tools/secretfinder/SecretFinder.py -i $v -e -o cli >  $dir/$1_secretfinder.txt;
 




