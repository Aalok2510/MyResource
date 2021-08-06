#!/bin/bash 
# Global variables
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
RESET=`tput sgr0`
Recon_path=/root/mediumrecon/$1
echo "${GREEN}$(mkdir -vp $Recon_path{,/{wordlist,arjun,subdomains,parameters,blc,corsy,nmap_scan,dirfuzz,dirfuzz1,mass_scan,brutespray,gf}})${RESET}"


echo '_________________________________________________________'
echo  "${red} Performing : ${green} Subdomain Enumeration  ${reset}"
echo '---------------------------------------------------------'
DIR="$Recon_path/subdomains"
echo "Recon has started on" "$1" $(date) |  notify  -discord -discord-webhook-url  https://discord.com/api/webhooks/841595351957897236/09DJo1Wehd_yaIjILS35hF8WQga0vm2K1lWhX8Sm7HKoKzKVkJ26xHRi5ohp-ChXqPc- -discord-username Eli &>/dev/null
subfinder -silent -config /root/.config/subfinder/config.yaml -d $1 -all -o $DIR/list_subdomain.txt
assetfinder -subs-only $1 >> $DIR/list_subdomain.txt 
amass enum -passive -silent -config /root/.config/amass/config.ini -d $1 -rf /opt/50resolver.txt >> $DIR/list_subdomain.txt
cat  /opt/best-dns-wordlist.txt | puredns  bruteforce $1 -r /opt/resolvers.txt -w $DIR/list_subdomain.txt
massdns -r /opt/50resolver.txt -q -t A -o S -w $DIR/massdns.txt $DIR/list_subdomain.txt ; cat $DIR/massdns.txt | sed 's/A.*// ; s/CN.*// ; s/\..$//' | sort -u > $DIR/tmp_subdomain.txt
grep $1 $DIR/tmp_subdomain.txt > $DIR/all_subdomain.txt
rm -rf $DIR/{list_subdomain.txt,tmp_subdomain.txt}

#Starting Probing

sort -u $DIR/all_subdomain.txt | httpx -silent > $DIR/httpx_subdomain.txt
sort -u $DIR/all_subdomain.txt | httprobe > $DIR/httprobe_subdomain.txt
httpx -l $DIR/all_subdomain.txt -follow-redirects -status-code -vhost -threads 100 -silent -no-color | sort -u | grep "\[200\]" | cut -d '[' -f1 | uniq > $DIR/200_subdomain.txt
httpx -l $DIR/all_subdomain.txt -follow-redirects -status-code -vhost -threads 100 -silent -no-color | sort -u | grep "\[403\]" | cut -d '[' -f1 | uniq > $DIR/403_subdomain.txt
httpx -l $DIR/all_subdomain.txt -follow-redirects -status-code -vhost -threads 100 -silent -no-color | sort -u | grep "\[404\]" | cut -d '[' -f1 | uniq > $DIR/404_subdomain.txt
sort -u $DIR/httpx_subdomain.txt $DIR/httprobe_subdomain.txt > $DIR/subdomain.txt 
sed 's/https\?:\/\///' $DIR/200_subdomain.txt > $DIR/200_without_http_subdomain.txt

# Aquatone

cat $Recon_path/subdomains/subdomain.txt | aquatone -silent -out $Recon_path/aquatone/ 

#Service-enumeration

NMAP_DIR="$Recon_path/nmap_scan"

python3 /opt/resolve.py -l  $Recon_path/subdomains/subdomain.txt  > $NMAP_DIR/ip.txt
python3 /opt/cleanip.py $NMAP_DIR/ip.txt $NMAP_DIR/result.txt
while read domain;do  rustscan -a $domain -t 600 -u 5000 -- -sV -oN $NMAP_DIR/$domain.xml;done  < $NMAP_DIR/result.txt
for xml_file in $NMAP_DIR/*.xml; do brutespray -f $xml_file -o $Recon_path/brutespray/$(sed 's/\.xml//' <<< $(basename $xml_file)) -t 20 -T 5; done


#Fuzzing Parameters

p_dir="$Recon_path/parameters"
all_para="$p_dir/params"
h_dir="$p_dir/high"
l_dir="$p_dir/low"
mkdir $h_dir $l_dir $all_para
while read domain; do waybackurls $domain; done < $Recon_path/subdomains/200_subdomain.txt | grep $1 | grep -Ev 'svg|ttf|woff|css|png|gif|jpeg|jpg' | sort -u >> $all_para/waybackurls.txt
while read domain; do gau -subs -b svg,ttf,woff,css,png,jpg,jpeg,gif $domain ; done < $Recon_path/subdomains/200_subdomain.txt | sort -u >> $all_para/gau.txt
while read domain; do arjun -q --stable -u $1 -oT $Recon_path/arjun/$(sed 's/https\?:\/\///' <<< $domain).txt -t 20; done < $Recon_path/subdomains/200_subdomain.txt 
while read domain; do python3 /opt/ParamSpider/paramspider.py --quiet -d $domain -l high -e woff,css,png,svg,jpg --output $h_dir/$domain.txt 1>/dev/null ; done < $Recon_path/subdomains/200_without_http_subdomain.txt
while read domain; do python3 /opt/ParamSpider/paramspider.py --quiet -d $domain -l low -e woff,css,png,svg,jpg --output $l_dir/$domain.txt  ; done < $Recon_path/subdomains/200_without_http_subdomain.txt
sort -u $h_dir/* >> $p_dir/parameters.txt
sort -u $l_dir/* >> $p_dir/parameters.txt
sort -u $all_para/* >> $p_dir/parameters.txt 
sort -u $p_dir/parameters.txt > $p_dir/parameter.txt
rm -r $p_dir/parameters.txt

#Vulnerability scanning
while read domain; do  dig  +short  $domain >> $Recon_path/dig.txt;done < $Recon_path/subdomains/all_subdomain.txt
while read domain; do hakrawler  -url $domain --plain >> $Recon_path/crawl.txt;done < $Recon_path/subdomains/200_subdomain.txt  
while read domain; do python3 /opt/Corsy/corsy.py -q -u $domain >> $Recon_path/corsy.txt;done < $Recon_path/crawl.txt 	
while read domain; do python3 /opt/Corsy/corsy.py -q -u $domain -o $Recon_path/corsy/$(sed 's/https\?:\/\///' <<< $domain); done < $Recon_path/subdomains/200_subdomain.txt
cat $Recon_path/subdomains/200_subdomain.txt | while read domain; do blc  $domain | tee $Recon_path/blc/$(sed 's/https\?:\/\///' <<< $domain) 1>/dev/null ; done 
cat $Recon_path/subdomains/subdomain.txt | python3 /opt/FavFreak/favfreak.py --shodan > $Recon_path/favfreak_output.txt
subzy -targets $Recon_path/subdomains/subdomain.txt --hide_fails > $Recon_path/subzy.txt
subjack -w $Recon_path/subdomains/subdomain.txt -t 20 -timeout 30 -o $Recon_path/subjack.txt -ssl -v 
python3 /opt/sub404/sub404.py -f $Recon_path/subdomains/subdomain.txt -o $Recon_path/sub404.txt
python3 /opt/takeover.py -l $Recon_path/subdomains/subdomain.txt -o $Recon_path/takeover.txt -T 3 1>/dev/null
nuclei -l $Recon_path/subdomains/subdomain.txt -t $HOME/nuclei-templates/ -c 21 -v -o $Recon_path/nuclei.txt
while read domain; do /opt/byp4xx.sh -c -r $domain >> $Recon_path/byp4xx.txt; done < $Recon_path/subdomains/403_subdomain.txt
gf xss $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/xss
gf redirect $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/redirect
gf ssti $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/ssti
gf ssrf $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/ssrf
gf sqli $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/sqli
gf rce $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/rce
gf idor $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/idor
gf lfi $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/lfi
gf potential $Recon_path/parameters/parameter.txt |  cut -d : -f3- | sort -u > $Recon_path/gf/potential
gf debug_logic $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/debug_logic
gf xss $Recon_path/parameters/parameter.txt | sed 's/=.*/=/;s/URL: //' | sort -u | dalfox pipe -b blind.xss.ht -o $Recon_path/dalfox_result.txt 1>/dev/null
crlfuzz -l $Recon_path/subdomains/subdomain.txt -o $Recon_path/crlfuzz.txt 
cat $Recon_path/subdomains/200_without_http_subdomain.txt | python3 /opt/smuggler/smuggler.py -l $Recon_path/smuggler.txt
while read domain; do python3 /opt/SecretFinder/SecretFinder.py -i $domain -e -o cli; done < $Recon_path/subdomains/200_subdomain.txt > $Recon_path/secretfinder_output.txt 
grep 'google_api' -B 1 $Recon_path/secretfinder_output.txt | sort -u > $Recon_path/google_api.txt
while read domain; do echo 'QUIT' | openssl s_client -connect $domain:443 2>&1 | grep 'server extension "heartbeat" (id=15)' || echo $domain': safe'; done < $Recon_path/subdomains/200_subdomain.txt >> $Recon_path/heartbleed.txt

#Gentrating wordlist_all using Key,Path	
cat $Recon_path/parameters/parameter.txt | unfurl -u keys > $Recon_path/wordlist/keys.txt
cat $Recon_path/parameters/parameter.txt | unfurl -u paths | sed 's#/#\n#g' > $Recon_path/wordlist/path.txt
cat $Recon_path/wordlist/*.txt | sort -u | uniq > $Recon_path/wordlist/wordlist_all.txt
rm -r $Recon_path/wordlist/{keys,path}.txt
subjs -i $Recon_path/parameters/parameter.txt -c 20 -t 5 | sort -u > $Recon_path/wordlist/subjs.txt
cat $Recon_path/wordlist/subjs.txt | xargs -P 2 -L 1 -i curl {} | tee $Recon_path/wordlist/jscont_tmp
cat $Recon_path/wordlist/jscont_tmp | sort -u | uniq > $Recon_path/wordlist/jscontents.txt
cat $Recon_path/wordlist/jscontents.txt | tok | tr '[:upper:]' '[:lower:]' | sort -u >> $Recon_path/wordlist/wordlist_all.txt
cat $Recon_path/subdomains/subdomain.txt | xargs -P 2 -i curl {} | tee $Recon_path/wordlist/httpcont_tmp
cat $Recon_path/wordlist/httpcont_tmp | sort -u | uniq >> $Recon_path/wordlist/wordlist_all.txt
cat $Recon_path/wordlist/wordlist_all.txt | sort -u | uniq > $Recon_path/wordlist/wordlist_tmp.txt
comm -13 /opt/rfc-words $Recon_path/wordlist/wordlist_tmp.txt > $Recon_path/wordlist/wordlist.txt


while read domain; do  h=$(echo $domain | sed -E 's/^\s*.*:\/\///g'); ffuf -mc all -c -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u $domain/FUZZ -w $Recon_path/wordlist/wordlist.txt -fc 404,429 -t 50 -D -e .php,.bak,.txt,.jsp,.html,.sql,.json,.log,.yaml,.config -ac -se -o $Recon_path/dirfuzz/$h.json;done < $Recon_path/subdomains/200_subdomain.txt



while read domain; do z=$(echo $domain | sed -E 's/^\s*.*:\/\///g');ffuf -mc all -c -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u $domain/FUZZ -w /root/wordlist/wordlist.txt -fc 404,429  -t 50 -D -e .php,.bak,.txt,.jsp,.html,.sql,.json,.log,.yaml,.config -ac -se -o $Recon_path/dirfuzz1/$z.json; done <$Recon_path/subdomains/200_subdomain.txt

for json_file in $Recon_path/dirfuzz/*.json; do cat $json_file | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $Recon_path/Cdirectory.txt ; done 

for json_file in $Recon_path/dirfuzz1/*.json; do cat $json_file | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $Recon_path/Mdirectory.txt; done 
find $Recon_path -type f -size 0 -delete;
find $Recon_path/wordlist -type f -size 0 -delete;
find $Recon_path/arjun -type f -size 0 -delete;
find $Recon_path/subdomains -type f -size 0 -delete;
find $Recon_path/parameters -type f -size 0 -delete;
find $Recon_path/blc -type f -size 0 -delete;
find $Recon_path/corsy -type f -size 0 -delete;
find $Recon_path/nmap_scan -type f -size 0 -delete;
find $Recon_path/dirfuzz -type f -size 0 -delete;
find $Recon_path/mass_scan -type f -size 0 -delete;
find $Recon_path/brutespray -type f -size 0 -delete;
find $Recon_path/gf -type f -size 0 -delete;
echo "Recon has ended on" "$1" $(date) |  notify  -discord -discord-webhook-url https://discord.com/api/webhooks/841595351957897236/09DJo1Wehd_yaIjILS35hF8WQga0vm2K1lWhX8Sm7HKoKzKVkJ26xHRi5ohp-ChXqPc- -discord-username Eli &>/dev/null

