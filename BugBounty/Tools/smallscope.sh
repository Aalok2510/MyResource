#!/bin/bash

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`
shopt -s expand_aliases
alias httpx=/home/hack2death/go/bin/./httpx
alias linkfinder='python3 /home/hack2death/Tools/LinkFinder/linkfinder.py -o cli -i '
alias paramspider='python3 /home/hack2death/Tools/ParamSpider/paramspider.py  --subs False  -e  png,jpeg,ico,css,svg,gif,js -d '
alias secretfinder='python3 /home/hack2death/Tools/secretfinder/SecretFinder.py -e -o cli -i'
alias  gau=/home/hack2death/go/bin/./gau
alias  waybackurls=/home/hack2death/go/bin/./waybackurls
alias  gf=/home/hack2death/go/bin/./gf
alias corsy='python3 /home/hack2death/Tools/Corsy/corsy.py -t 10 -u '
alias crlfuzz=/home/hack2death/go/bin/./crlfuzz
alias nuclei='/home/hack2death/go/bin/./nuclei -c 200 -silent  -t /home/hack2death/Tools/nuclei-templates/ -target '
alias ffuf=/home/hack2death/go/bin/./ffuf


echo '_________________________________________________________'
echo  "${red} Performing : ${green} Finding Links,Broken Links and Parameter ${reset}"
echo '---------------------------------------------------------'

dir=/home/hack2death/smallRecon/$1
dir=/home/hack2death/smallRecon
mkdir  $dir;
v=$(echo $1 | httpx) 
linkfinder $v >> $dir/$1_linkfinder.txt
paramspider $1 -l low -o $dir/$1_low.txt
paramspider $1 -l high -o $dir/$1_high.txt
cat $dir/$1_high.txt >>  $dir/$1_low.txt
cat $dir/$1_low.txt | sort -u >> $dir/$1_parameter.txt
rm -r $dir/$1_low.txt  $dir/$1_high.txt;
blc  $v   >>  $dir/$1_brokenlink.txt

echo '______________________________________________________________________'
echo  "${red} Performing : ${green}  secretFinding ${reset}"
echo '----------------------------------------------------------------------' 

secretfinder $v  >  $dir/$1_secretfinder.txt;

echo '______________________________________________________________________'
echo  "${red} Performing : ${green} Finding urls and potential parameter ${reset}"
echo '----------------------------------------------------------------------'
    
waybackurls  -no-subs  $1 > $dir/urls;gau $1 >> $dir/urls;cat $dir/urls | sort -u > $dir/$1_final_urls;
rm -r $dir/urls;
gf xss $dir/$1_final_urls | cut -d : -f3- | sort -u > $dir/$1_xss;
gf ssti $dir/$1_final_urls | sort -u > $dir/$1_ssti
gf ssrf $dir/$1_final_urls | sort -u > $dir/$1_ssrf
gf sqli $dir/$1_final_urls | sort -u > $dir/$1_sqli
gf redirect  $dir/$1_final_urls | cut -d : -f2- | sort -u > $dir/$1_redirect
gf rce  $dir/$1_final_urls | sort -u > $dir/$1_rce
gf idor  $dir/$1_final_urls | sort  -u > $dir/$1_idor
gf lfi  $dir/$1_final_urls | sort -u > $dir/$1_lfi

echo '______________________________________________________________________'
echo  "${red} Performing : ${green} Service Enumeration and other Enumeration ${reset}"
echo '----------------------------------------------------------------------'

corsy $v >  $dir/$1_corsy;
crlfuzz  -u  $v > $dir/$1_crlfuzz;
nuclei  $v -o $dir/$1_nuclei;

echo $v | python3 /home/hack2death/Tools/FavFreak/favfreak.py --shodan  > $dir/$1_faver
cat $dir/$1_faver | grep 'h]' | cut -d ] -f2 | cut -d " " -f2 | tee $dir/$1_favhash_domain

python3 /home/hack2death/Tools/smuggler/smuggler.py -u $1 > $dir/$1_smuggler



echo  $v > $dir/$1_url.txt
python3 /home/hack2death/Tools/resolve.py -l $dir/$1_url.txt > $dir/$1_ip.txt
rm -r $dir/$1_url.txt
python3 /home/hack2death/Tools/cleanip.py $dir/$1_ip.txt $dir/$1_result
a=$(cat $dir/$1_result)
i=$(cat $dir/$1_ip.txt)
rm -r $dir/$1_ip.txt
if [ -z $a]
then 
    echo "Protected by cloudfare" >  $dir/$1_nmap.txt
else 
    rustscan $i -t 600 -u 5000 -- -sV -oN  $dir/$1_nmap.txt
fi
rm -r $dir/$1_result

echo '______________________________________________________________________'
echo  "${red} Performing : ${green} Directory Bruteforcing ${reset}"
echo '----------------------------------------------------------------------'
ffuf -mc all -c  -w /home/hack2death/wordlist/dicc.txt  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u $v/FUZZ -D -e js,php,bak,txt,asp,aspx,jsp,html,zip,jar,sql,json,,old,gz,shtml,log,swp,yaml,yml,config,save,rsa,ppk -t 30 -ac -o $dir/$1.temp

cat $dir/$1.temp | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' > $dir/$1_directory.txt

rm -r  $dir/$1.temp;

echo '_________________________________________________________'
echo  "${red} Performing : ${green} Finished  ${reset}"
echo '---------------------------------------------------------'
