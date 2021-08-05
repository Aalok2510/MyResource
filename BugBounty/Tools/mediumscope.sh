#!/bin/bash
set -e

# Global variables
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
RESET=`tput sgr0`


Recon_path="$HOME/mediumRecon/$1"
echo "${GREEN}$(mkdir -vp $Recon_path{,/{wordlist,arjun,high,low,subdomains,parameters,aquatone,blc,corsy,nmap_scan,dirfuzz1,dirfuzz2,mass_scan,brutespray,gf}})${RESET}"


subfinder -silent -d $1 -all >> $Recon_path/subdomains/list_subdomain.txt
assetfinder -subs-only $1 >> $Recon_path/subdomains/list_subdomain.txt 
amass enum -passive -silent -config $HOME/.config/amass/config.ini -d $1 -rf ~/Tools/50resolver.txt >> $Recon_path/subdomains/list_subdomain.txt
massdns -r /Tools/50resolver.txt -q -t A -o S -w $Recon_path/subdomains/massdns.txt $Recon_path/subdomains/list_subdomain.txt ; cat $Recon_path/subdomains/massdns.txt | sed 's/A.*// ; s/CN.*/25/;s/\..$//' | sort -u > $Recon_path/subdomains/tmp_subdomain.txt 
grep $1 $Recon_path/subdomains/tmp_subdomain.txt > $Recon_path/subdomains/all_subdomain.txt

rm -rf $Recon_path/subdomains/{list_subdomain.txt,tmp_subdomain.txt}

sort -u $Recon_path/subdomains/all_subdomain.txt | httpx -silent > $Recon_path/subdomains/httpx_subdomain.txt
sort -u $Recon_path/subdomains/all_subdomain.txt | httprobe > $Recon_path/subdomains/httprobe_subdomain.txt
httpx -l $Recon_path/subdomains/all_subdomain.txt -follow-redirects -status-code -vhost -threads 100 -silent -no-color | sort -u | grep "\[200\]" | cut -d '[' -f1 | uniq > $Recon_path/subdomains/200_subdomain.txt 
httpx -l $Recon_path/subdomains/all_subdomain.txt -follow-redirects -status-code -vhost -threads 100 -silent -no-color | sort -u | grep "\[403\]" | cut -d '[' -f1 | uniq > $Recon_path/subdomains/403_subdomain.txt
sort -u $Recon_path/subdomains/httpx_subdomain.txt $Recon_path/subdomains/httprobe_subdomain.txt > $Recon_path/subdomains/subdomain.txt 
sed 's/https\?:\/\///' $Recon_path/subdomains/200_subdomain.txt > $Recon_path/subdomains/200_without_http_subdomain.txt

cat $Recon_path/subdomains/subdomain.txt | aquatone -silent -out $Recon_path/aquatone/
```
python3 /Tools/resolver.py $s/subdomain.txt

do later  

```



while read domain; do waybackurls $domain; done < $Recon_path/subdomains/200_subdomain.txt | grep $1 | grep -Ev 'svg|ttf|woff|css|png|gif|jpeg|jpg' | sort -u > $Recon_path/parameters/waybackurls.txt 
while read domain; do gau -subs -b svg,ttf,woff,css,png,jpg,jpeg,gif $domain ; done < $Recon_path/subdomains/200_subdomain.txt | sort -u > $Recon_path/parameters/gau.txt 
while read domain; do arjun -q --stable -u $domain -oT $Recon_path/arjun/$(sed 's/https\?:\/\///' <<< $domain).txt -t 20; done < $Recon_path/subdomains/200_subdomain.txt
while read domain; do python3 ~/Tools/ParamSpider/paramspider.py --quiet -d $domain -l high -e woff,css,png,svg,jpg --output  $Recon_path/high/$domain.txt 1>/dev/null ; done < $Recon_path/subdomains/200_without_http_subdomain.txt
while read domain; do python3 ~/Tools/ParamSpider/paramspider.py --quiet -d $domain -l low -e woff,css,png,svg,jpg --output  $Recon_path/low/$domain.txt 1>/dev/null ; done < $Recon_path/subdomains/200_without_http_subdomain.txt
sort -u $Recon_path/parameters/* > $Recon_path/parameters/parameters.txt
cat $Recon_path/high/* >> $Recon_path/parameters/parameters.txt
cat $Recon_path/low/*  >>  $Recon_path/parameters/parameters.txt
sort -u  $Recon_path/parameters/parameters.txt >  $Recon_path/parameters/parameter.txt
rm -r $Recon_path/parameters/parameters.txt




while read domain; do hakrawler --url $domain --plain >>$Recon_path/crawl.txt;done < $Recon_path/subdomains/200_subdomain.txt
while read domain; do python3 ~/Tools/Corsy/corsy.py -q -u $domain >> $Recon_path/corsy.txt; done < $Recon_path/crawl.txt      
while read domain; do python3 ~/Tools/Corsy/corsy.py -q -u $domain -o $Recon_path/corsy/$(sed 's/https\?:\/\///' <<< $domain); done < $Recon_path/subdomains/200_subdomain.txt
cat $Recon_path/subdomains/200_subdomain.txt | while read domain; do blc $domain | tee $Recon_path/blc/$(sed 's/https\?:\/\///' <<< $domain) 1>/dev/null ; done
cat $Recon_path/subdomains/subdomain.txt | python3 ~/Tools/FavFreak/favfreak.py --shodan | grep '\[Hash\]' | awk '{print $2}' >> $Recon_path/favfreak_output.txt 

subzy -targets $Recon_path/subdomains/subdomain.txt --hide_fails
subjack -w $Recon_path/subdomains/subdomain.txt -t 20 -timeout 30 -o $Recon_path/subjack.txt -ssl -v 
python3 ~/Tools/sub404/sub404.py -f $Recon_path/subdomains/subdomain.txt -o $Recon_path/sub404.txt 
python3 ~/Tools/takeover.py -l $Recon_path/subdomains/subdomain.txt -o $Recon_path/takeover.txt


nuclei -l $Recon_path/subdomains/subdomain.txt -t ~/Tools/nuclei-templates/ -c 21 -v -o $Recon_path/nuclei.txt
while read domain; do ~/Tools/byp4xx.sh -c -r $domain >> $Recon_path/byp4xx.txt; done < $Recon_path/subdomains/403_subdomain.txt

gf xss $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/xss 
gf redirect $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/redirect
gf ssti $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/ssti
gf ssrf $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/ssrf
gf sqli $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/sqli
gf rce $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/rce
gf idor $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/idor
gf lfi  $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/lfi
gf potential $Recon_path/parameters/parameter.txt |  cut -d : -f3- | sort -u > $Recon_path/gf/potential
gf debug_logic $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/debug_logic

crlfuzz -l $Recon_path/subdomains/subdomain.txt -o $Recon_path/crlfuzz.txt 
cat $Recon_path/subdomains/200_without_http_subdomain.txt | python3 ~/Tools/smuggler/smuggler.py -l $Recon_path/smuggler.txt
while read domain; do python3 ~/Tools/SecretFinder/SecretFinder.py -i $domain -e -o cli; done < $Recon_path/subdomains/200_subdomain.txt > $Recon_path/secretfinder_output.txt 
while read domain; do echo 'QUIT' | openssl s_client -connect $domain:443 2>&1 | grep 'server extension "heartbeat" (id=15)' || echo $domain': safe'; done < $Recon_path/subdomains/200_subdomain.txt >> $Recon_path/heartbleed.txt

h_domain=$(echo $1  | httpx)

cat $Recon_path/parameters/waybackurls.txt | unfurl -u keys > $Recon_path/wordlist/keys.txt
cat $Recon_path/parameters/waybackurls.txt | unfurl -u paths | sed 's#/#\n#g' > $Recon_path/wordlist/path.txt
cat $Recon_path/wordlist/*.txt | sort -u | uniq > $Recon_path/wordlist/wordlist_all.txt
rm -r $Recon_path/wordlist/{keys,path}.txt
subjs -i $Recon_path/parameters/waybackurls.txt -c 20 -t 5 | sort -u > $Recon_path/wordlist/subjs.txt
cat $Recon_path/wordlist/subjs.txt | xargs -P 2 -L 1 -i curl {} | tee $Recon_path/wordlist/jscont_tmp
cat $Recon_path/wordlist/jscont_tmp | sort -u | uniq > $Recon_path/wordlist/jscontents.txt
cat $Recon_path/wordlist/jscontents.txt | tok | tr '[:upper:]' '[:lower:]' | sort -u >> $Recon_path/wordlist/wordlist_all.txt
cat $Recon_path/subdomain/subdomain.txt | xargs -P 2 -i curl {} | tee $Recon_path/wordlist/httpcont_tmp
cat $Recon_path/wordlist/httpcont_tmp | sort -u | uniq >> $Recon_path/wordlist/wordlist_all.txt
cat $Recon_path/wordlist/wordlist_all.txt | sort -u | uniq > $Recon_path/wordlist/wordlist_tmp.txt
comm -13 ~/Tools/rfc-words $Recon_path/wordlist/wordlist_tmp.txt > $Recon_path/wordlist/wordlist.txt



while read domain; do ffuf -mc all -fc 404,429  -c -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$domain"/FUZZ -w $Recon_path/wordlist/wordlist.txt -t 50 -D -e .php,.bak,.txt,.jsp,.html,.sql,.json,.aspx,.asp,.log,.yaml,.config -ac -se -o $Recon_path/dirfuzz1/${url##*/}.temp;done < $Recon_path/subdomain/200_subdomain.txt
cat $Recon_path/dirfuzz1/* | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7}) url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $Recon_path/wordlistfuzz.txt















