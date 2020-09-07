#!/bin/bash
dir=/home/hack2death/Recon/$1
shopt -s expand_aliases
alias  httprobe=/home/hack2death/bin/./httprobe
alias  gau=/home/hack2death/go/bin/./gau
alias  waybackurls=/home/hack2death/go/bin/./waybackurls
alias  gf=/home/hack2death/go/bin/./gf
alias  crlfuzz=/home/hack2death/go/bin/./crlfuzz
alias  nuclei=/home/hack2death/go/bin/./nuclei
v=$(echo $1 | httprobe -r -prefers-https )

waybackurls  -no-subs  $1 > $dir/urls;gau $1 >> $dir/urls;cat $dir/urls | sort -u > $dir/$1_final_urls;
rm -r $dir/urls;
gf xss $dir/$1_final_urls | cut -d : -f3- | sort -u > $dir/$1_xss;
gf ssti $dir/$1_final_urls | sort -u > $dir/$1_ssti
gf ssrf $dir/$1_final_urls | sort -u > $dir/$1_ssrf
gf sqli $dir/$1_final_urls | sort -u > $dir/$1_sqli
gf redirect  $dir/$1_final_urls | cut -d : -f2- | sort -u > $dir/$1_redirect
gf rce  $dir/$1_final_urls | sort -u > $dir/$1_rce
gf potential $dir/$1_final_urls| cut -d : -f3- | sort -u > $dir/$1_potential
gf idor  $dir/$1_final_urls | sort  -u > $dir/$1_idor
gf lfi  $dir/$1_final_urls | sort -u > $dir/$1_lfi
python3 /home/hack2death/Tools/Corsy/corsy.py -u $v -t  10 >  $dir/$1_corsy
python  /home/hack2death/Tools/CORScanner/cors_scan.py  -u  $v  -d "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US) AppleWebKit/527  (KHTML, like Gecko, Safari/419.3) Arora/0.6 (Change: )"  >  $dir/>
crlfuzz  -u  $v > $dir/$1_crlfuzz;
nuclei  -target  $v  -c 200 -silent  -t /home/hack2death/Tools/nuclei-templates/   -o  $dir/$1_nuclei 
python3 /home/hack2death/Tools/Parth/parth.py   -ut  $v  >  $dir/$1_parth





