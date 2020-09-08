#!/bin/bash
shopt -s expand_aliases
alias httpx=/home/hack2death/Tools/./httpx
alias linkfinder='python3 /home/hack2death/Tools/LinkFinder/linkfinder.py -o cli -i '
alias paramspider='python3 /home/hack2death/Tools/ParamSpider/paramspider.py  --subs False  -e  png,jpeg,ico,css,svg,gif,js -d '

dir=/home/hack2death/Recon/$1
mkdir  $dir;
v=$(echo $1 | httpx) 
linkfinder $1 >> $dir/$1_linkfinder.txt
paramspider $1 -l low -o $dir/$1_low.txt
paramspider $1 -l high -o $dir/$1_high.txt
cat $dir/$1_high.txt >>  $dir/$1_low.txt
cat $dir/$1_low.txt | sort -u >> $dir/$1_parameter.txt
rm -r $dir/$1_low.txt  $dir/$1_high.txt;
blc  $v   >>  $dir/$1_brokenlink.txt










