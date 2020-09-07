#!/bin/bash
shopt -s expand_aliases
alias httpx=/home/hack2death/Tools/./httpx
dir=/home/hack2death/Recon/$1
mkdir  $dir;
v=$(echo $1 | httpx) 
python3 /home/hack2death/Tools/LinkFinder/linkfinder.py   -i $v -o cli >> $dir/$1_linkfinder.txt
python3 /home/hack2death/Tools/ParamSpider/paramspider.py -d $v --subs False  -e  png,jpeg,ico,css,svg,gif,js -l high -o $dir/$1_paramspider.txt
blc  $v   >>  $dir/$1_brokenlink.txt










