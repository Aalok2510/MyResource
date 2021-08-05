 #!/bin/bash
# Global variables
RED=`tput setaf 1`
GREEN=`tput setaf 2`
YELLOW=`tput setaf 3`
BLUE=`tput setaf 4`
RESET=`tput sgr0`
Recon_path=~/smallRecon/$1
mkdir $Recon_path

p=$Recon_path/parameters
g=$Recon_path/gf
w=$Recon_path/wordlist
mkdir $g $p $w
v=$(echo $1 | httpx)

waybackurls $v | grep $1 | grep -Ev 'svg|ttf|woff|css|png|gif|jpeg|jpg' | sort -u > $Recon_path/parameters/waybackurls.txt
gau  -b svg,ttf,woff,css,png,jpg,jpeg,gif $v | sort -u > $Recon_path/parameters/gau.txt
arjun -q --stable -u $v -oT $Recon_path/parameters/arjun.txt
python3 ~/Tools/ParamSpider/paramspider.py -q -d $v -l high -e woff,css,png,svg,jpg --output $Recon_path/parameters/hparamspider.txt
python3 ~/Tools/ParamSpider/paramspider.py -q -d $v -l low -e woff,css,png,svg,jpg --output $Recon_path/parameters/lparamspider.txt
cat $Recon_path/waybackurls.txt $Recon_path/gau.txt $Recon_path/hparamspider.txt $Recon_path/parameters/lparamspider.txt | sort -u  > $Recon_path/parameters/parameter.txt


hakrawler -url $v --plain > $Recon_path/crawl.txt
while read domain; do python3 ~/Tools/Corsy/corsy.py -q -u $domain -o  $Recon_path/corsy.txt;done < $Recon_path/crawl.txt
blc $v | tee $Recon_path/blc.txt
echo $v| python3 ~/Tools/FavFreak/favfreak.py --shodan > $Recon_path/favfreak_output.txt
getJS --url $v  > $Recon_path/js.txt
nuclei -u $v -t ~/Tools/nuclei-templates/  -v -o $Recon_path/nuclei.txt


gf xss $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/xss
gf redirect $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/redirect
gf ssti $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/ssti
gf ssrf $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/ssrf
gf sqli $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/sqli 
gf rce $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/rce
gf idor $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/idor
gf lfi $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/lfi
gf interestingparams $Recon_path/parameters/parameter.txt |  cut -d : -f3- | sort -u > $Recon_path/gf/interestingparams
gf debug_logic $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/debug_logic
gf  interestingEXT $Recon_path/parameters/parameter.txt | sort -u > $Recon_path/gf/interestingEXT


crlfuzz -u $v -o $Recon_path/crlfuzz.txt
smuggler -u $v > $Recon_path/smuggler.txt
python3 ~/Tools/SecretFinder/SecretFinder.py -i $v -e -o cli > $Recon_path/secretfinder_output.txt


cat $Recon_path/parameters/parameter.txt | unfurl -u keys > $Recon_path/wordlist/keys.txt
cat $Recon_path/parameters/parameters.txt | unfurl -u paths | sed 's#/#\n#g' > $Recon_path/wordlist/path.txt
cat $Recon_path/wordlist/*.txt | sort -u | uniq > $Recon_path/wordlist/wordlist_all.txt
rm -r $Recon_path/wordlist/{keys,path}.txt
subjs -i $Recon_path/parameters/parameters.txt -c 20 -t 5 | sort -u > $Recon_path/wordlist/subjs.txt
cat $Recon_path/wordlist/subjs.txt | xargs -P 2 -L 1 -i curl {} | tee $Recon_path/wordlist/jscont_tmp
cat $Recon_path/wordlist/jscont_tmp | sort -u | uniq > $Recon_path/wordlist/jscontents.txt
cat $Recon_path/wordlist/jscontents.txt | tok | tr '[:upper:]' '[:lower:]' | sort -u >> $Recon_path/wordlist/wordlist_all.txt
curl $v | tee $Recon_path/wordlist/httpcont_tmp
cat $Recon_path/wordlist/httpcont_tmp | sort -u | uniq >> $Recon_path/wordlist/wordlist_all.txt
cat $Recon_path/wordlist/wordlist_all.txt | sort -u | uniq > $Recon_path/wordlist/wordlist_tmp.txt
comm -13 ~/Tools/rfc-words $Recon_path/wordlist/wordlist_tmp.txt > $Recon_path/wordlist/wordlist.txt

#wordlist_all.txt --- contents all word may be dups
#wordlist_tmp.txt --- Sorted but contents rfc words
#wordlist.txt     --- Final wordlist

ffuf -mc all -fc 404,429  -c -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$v"/FUZZ -w $Recon_path/wordlist/wordlist.txt -t 50 -D -e .php,.bak,.txt,.jsp,.html,.sql,.json,.log,.yaml,.config -ac -se -o $Recon_path/temp
cat $Recon_path/temp | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $Recon_path/manualFuzz.txt
rm -r $Recon_path/tmp
ffuf -mc all -fc 404,429  -c  -H "User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:72.0) Gecko/20100101 Firefox/72.0" -u "$v"/FUZZ -w ~/recon/scripts/wordlist/wordlist.txt -t 50 -D -e .php,.bak,.txt,.jsp,.html,.sql,.json,.log,.yaml,.config -ac -se -o $Recon_path/temp
cat $Recon_path/temp | jq '[.results[]|{status: .status, length: .length, url: .url}]' | grep -oP "status\":\s(\d{3})|length\":\s(\d{1,7})|url\":\s\"(http[s]?:\/\/.*?)\"" | paste -d' ' - - - | awk '{print $2" "$4" "$6}' | sed 's/\"//g' >> $Recon_path/wordlistfuzz.txt
rm -r $Recon_path/temp

find $Recon_path -type f -size 0 -delete;
find $p -type f -size 0 -delete;
find $g -type f -size 0 -delete;
find $w -type f -size 0 -delete;






