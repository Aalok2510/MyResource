#!/bin/bash

dir=/home/hack2death/Recon/$1
shopt -s expand_aliases

alias httprobe=/home/hack2death/go/bin/./httprobe
alias ffuf=/home/hack2death/go/bin/./ffuf
v=$(echo $1 | httprobe -prefer-https) 
ffuf  -c -H "X-Forwarded-For: 127.0.0.1" -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$v/FUZZ" -w /home/hack2death/wordlist/dicc.txt -D -e js,php,bak,txt,asp,aspx,js>

cat $dir/$1_a.tmp | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4">
rm -r  $dir/$1_a.tmp



