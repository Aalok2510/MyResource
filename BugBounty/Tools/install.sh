#!/bin/bash -i
#exit is error occur
#set -e
#trap 'catch $? $LINENO' EXIT
#c#atch() {
#	  echo "ERRRROR"
#	    if [ "$1" != "0" ]; then
		        # error handling goes here
	#		    echo "Error $1 occurred on $2"
	#		      fi
	#	      }
	      #seting COlor
	 #     green=`tput setaf 2`
	      #reset=`tput sgr0`

	      echo ${green}Installing Tools${reset}
	      clear;
	      apt-get update -y &>/dev/null && echo -e ${green} Update  "\xE2\x9C\x94" ${reset};
	      apt-get install git -y &>/dev/null && echo -e ${green} git  "\xE2\x9C\x94" ${reset};
	      apt-get install wget -y &>/dev/null && echo -e ${green} wget  "\xE2\x9C\x94" ${reset};
	      apt-get install curl -y &>/dev/null && echo -e ${green} curl  "\xE2\x9C\x94" ${reset};
	      apt-get install tmux -y &>/dev/null && echo -e ${green} tmux  "\xE2\x9C\x94" ${reset};
	      apt-get install python3-pip  -y &>/dev/null && echo -e ${green} python3-pip  "\xE2\x9C\x94" ${reset};
	      apt-get install update &>/dev/null && echo -e ${green} update  "\xE2\x9C\x94" ${reset};
	      apt-get install python-pip -y &>/dev/null && echo -e ${green} python-pip  "\xE2\x9C\x94" ${reset};
	      apt-get install masscan -y &>/dev/null && echo -e ${green} masscan   "\xE2\x9C\x94" ${reset};
	      apt-get install nmap -y &>/dev/null &&  echo -e ${green} nmap  "\xE2\x9C\x94" ${reset};
	      apt-get install brutespray -y &>/dev/null && echo -e ${green} brutespray  "\xE2\x9C\x94" ${reset};
	      apt-get install chromium -y &>/dev/null && echo -e ${green} chromium  "\xE2\x9C\x94" ${reset};
	      apt-get update &>/dev/null && echo -e ${green} Update  "\xE2\x9C\x94" ${reset};
	      apt-get install npm -y &>/dev/null && echo -e ${green} npm  "\xE2\x9C\x94" ${reset};
	      apt-get install libpcap-dev -y &>/dev/null && echo -e ${green} LibPcap-Dev "\xE2\x9C\x94" ${reset};
	      apt-get install sqlmap -y &>/dev/null && echo -e ${green} SQLmap "\xE2\x9C\x94" ${reset};
	      npm install broken-link-checker -g &>/dev/null && echo -e ${green} broken-link-checker  "\xE2\x9C\x94" ${reset};
          apt install jq ;
	     # wget https://raw.githubusercontent.com/lobuhi/byp4xx/main/byp4xx.sh -O /Tools/byp4xx.sh &>/dev/null;chmod u+x /Tools/byp4xx.sh &>/dev/null && echo -e ${green} Byp4xx "\xE2\x9C\x94" ${reset};
	      #curl https://gist.githubusercontent.com/Aalok2510/96c5e9b2505ce9c7cf65ea0fada94e37/raw/f8d429d22d460a834c16faac5ed472b25778c400/reslove.py -o /Tools/resolve.py &>/dev/null && echo -e ${green} Resolve_Domains.py "\xE2\x9C\x94" ${reset};
	      #curl https://gist.githubusercontent.com/Aalok2510/0bf53843dd4d253ff6296455332c3d77/raw/a261249e2fefc6948a0816d60995829b22cae0cf/cleanip.py -o /Tools/cleanip.py &>/dev/null && echo -e ${green} CleanIp_Cdn_ip.py "\xE2\x9C\x94" ${reset};
         zz=/root/Tools
		 mkdir $zz
	     #/ wget -q https://gist.githubusercontent.com/unkn-0wn/9aa89782e04906421ed555708197eac9/raw/2452ebe327d04e1a7f94f3033452a686d6f31f06/gistfile1.txt -O /Tools/rfc-words &>/dev/null &&  echo -e ${green} rfc-wrods "\xE2\x9C\x94" ${reset};
	      wget -q https://raw.githubusercontent.com/m4ll0k/takeover/master/takeover.py -O /Tools/takeover.py &>/dev/null &&  echo -e ${green} takeover.py "\xE2\x9C\x94" ${reset};
	    #  wget -q https://raw.githubusercontent.com/unkn-0wn/beg_bounty/main/resolver.py -O /Tools/resolver.py &>/dev/null &&  echo -e ${green} Resolver.py "\xE2\x9C\x94" ${reset};  
	      wget -q https://s3.amazonaws.com/assetnote-wordlists/data/manual/2m-subdomains.txt -O /Tools/2m-subdomains.txt &>/dev/null &&  echo -e ${green} 2m-subdomains "\xE2\x9C\x94" ${reset};  
	      git clone https://github.com/devanshbatham/ParamSpider ~/Tools/ParamSpider &>/dev/null ; pip3 install -r /Tools/ParamSpider/requirements.txt &>/dev/null && echo -e ${green} ParamSpider  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/m4ll0k/SecretFinder.git /Tools/SecretFinder &>/dev/null ; pip3 install -r /Tools/SecretFinder/requirements.txt &>/dev/null && echo -e ${green} SecretFinder  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/s0md3v/Corsy.git /Tools/Corsy &>/dev/null ; pip3 install -r /Tools/Corsy/requirements.txt &>/dev/null && echo -e ${green} Corsy  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/r3curs1v3-pr0xy/sub404.git /Tools/sub404 &>/dev/null; pip3 install -r /Tools/sub404/requirements.txt &>/dev/null && echo -e ${green} Sub404  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/GerbenJavado/LinkFinder.git /Tools/LinkFinder &>/dev/null ; pip3 install -r /Tools/LinkFinder/requirements.txt &>/dev/null ;python /Tools/LinkFinder/setup.py install &>/dev/null && echo -e ${green} LinkFinder  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/defparam/smuggler.git /Tools/smuggler &>/dev/null && echo -e ${green} smuggler  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/devanshbatham/FavFreak /Tools/FavFreak &>/dev/null ; pip3 install -r /Tools/FavFreak/requirements.txt &>/dev/null && echo -e ${green} FavFreak  "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/Tuhinshubhra/CMSeeK /Tools/CMSeek &>/dev/null ; pip3 install -r /Tools/CMSeek/requirments.txt &>/dev/null && echo -e ${green} CMSeek "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/epinna/tplmap.git /Tools/tplmap &>/dev/null ; pip3 install -r /Tools/tplmap/requirments.txt &>/dev/null && echo -e ${green} TPLmap "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/devanshbatham/OpenRedireX /Tools/OpenRedireX &>/dev/null && echo -e ${green} TPLmap "\xE2\x9C\x94" ${reset}; 
	      git cline https://github.com/ghostlulzhacks/s3brute.git /Tools/s3brute &>/dev/null && echo -e ${green} s3brute "\xE2\x9C\x94" ${reset}; 
	      git clone https://github.com/sa7mon/S3Scanner.git /Tools/S3Scanner &>/dev/null ; pip3 install -r /Tools/S3Scanner/requirements.txt &>/dev/null && echo -e ${green} S3Scanner "\xE2\x9C\x94" ${reset}; 
	      mkdir -p ~/.aws/ ; echo -e "[default] \naws_access_key_id=AKIAJJFW5YIDOVTLDUCA \naws_secret_access_key=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" > ~/.aws/credentials; echo -e "[default] \nregion=us-west-2 \noutput=json" > ~/.aws/config && echo -e ${green} AWScli "\xE2\x9C\x94" ${reset}; 
	      git clone https://github.com/commixproject/commix.git /Tools/commix ; python3 /Tools/commix/setup.py install &>/dev/null && echo -e ${green} Commix "\xE2\x9C\x94" ${reset}; 
	      pip3 install trufflehog &>/dev/null && echo -e ${green} TruffleHog "\xE2\x9C\x94" ${reset}; 
	      pip3 install xsrfprobe &>/dev/null && echo -e ${green} XSRFprobe "\xE2\x9C\x94" ${reset}; 
	      pip3 install dnsgen &>/dev/null && echo -e ${green} Dnsgen "\xE2\x9C\x94" ${reset}; 
	      pip3 install arjun  &>/dev/null && echo -e ${green} Arjun "\xE2\x9C\x94" ${reset}; 
	      echo ${green} Installing GO ....${reset}
	      wget "https://go.dev/dl/go1.17.5.linux-amd64.tar.gz" -O /tmp/go.tar.gz &>/dev/null;
	      tar -C /usr/local -xzf /tmp/go.tar.gz &>/dev/null;
	      rm -rf /tmp/go* ;
	      echo "export GOPATH=/root/go" >> $HOME/.bashrc ;
	      echo "export PATH=$PATH:/usr/local/go/bin:/root/go/bin/:$HOME/go/bin" >> $HOME/.bashrc ;
	      export GOROOT=/usr/local/go
	      export GOPATH=$HOME/go
	      export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
	      source $HOME/.bashrc && echo -e ${green} Sourced BashRc "\xE2\x9C\x94" ${reset};
	      echo -e ${green} $(go version)  "\xE2\x9C\x94" ${reset};
	      go &>/dev/null && echo -e ${green} GO "\xE2\x9C\x94" ${reset};
	      echo ${green} Installing GO ....${reset}

	      wget -q https://gist.githubusercontent.com/unkn-0wn/21bf8fe0468a30dced0d60fc48e8ffc1/raw/870c363f2d23e8d20c71c49233f7e62e0e9db476/50resolver -O /Tools/50resolver.txt  &>/dev/null && echo -e ${green} 50resolver "\xE2\x9C\x94" ${reset};
	      git clone https://github.com/nuncan/slurp.git ~/go/src/github.com/slurp ; cd ~/go/src/github.com/slurp/ && go build && cd &>/dev/null ; chmod +x ~/go/src/github.com/slurp/slurp && echo -e ${green} Slurp "\xE2\x9C\x94" ${reset};
	      wget https://raw.githubusercontent.com/tomnomnom/hacks/master/tok/main.go -O /tmp/main.go &>/dev/null && echo -e ${green} Downloaded Tok "\xE2\x9C\x94" ${reset};
	      cd /tmp/ && go build main.go ; mv /tmp/main /usr/bin/tok && echo -e ${green} tok  "\xE2\x9C\x94" ${reset};
	      go get -u github.com/ffuf/ffuf &>/dev/null && echo -e ${green} ffuf  "\xE2\x9C\x94" ${reset};
	      go get github.com/bgentry/heroku-go &>/dev/null && echo -e ${green} heroku-go  "\xE2\x9C\x94" ${reset};
	      go get github.com/gocarina/gocsv &>/dev/null && echo -e ${green} gocsv  "\xE2\x9C\x94" ${reset};
	      go get github.com/google/go-github/github &>/dev/null && echo -e ${green} github  "\xE2\x9C\x94" ${reset};
	      go get github.com/olekukonko/tablewriter &>/dev/null && echo -e ${green} tablewriter  "\xE2\x9C\x94" ${reset};
	      go get golang.org/x/net/publicsuffix &>/dev/null && echo -e ${green} publicsuffix  "\xE2\x9C\x94" ${reset};
	      go get golang.org/x/oauth2 &>/dev/null && echo -e ${green} oauth2  "\xE2\x9C\x94" ${reset};
	      go get github.com/miekg/dns &>/dev/null && echo -e ${green} dns  "\xE2\x9C\x94" ${reset};
	      go get github.com/anshumanbh/tko-subs &>/dev/null && echo -e ${green} tko-subs  "\xE2\x9C\x94" ${reset};
	      go get github.com/michenriksen/aquatone &>/dev/null && echo -e ${green} aquatone  "\xE2\x9C\x94" ${reset};
	      go get github.com/tomnomnom/waybackurls &>/dev/null && echo -e ${green} waybackurls  "\xE2\x9C\x94" ${reset};
	      go get -u -v github.com/lukasikic/subzy &>/dev/null && echo -e ${green} Subzy  "\xE2\x9C\x94" ${reset};
	      go get github.com/hakluke/hakrawler  &>/dev/null && echo -e ${green} hakrawler "\xE2\x9C\x94" ${reset};    
	      go get -u github.com/tomnomnom/gf &>/dev/null ;
              go get github.com/003random/getJS
              GO111MODULE=on go get -v github.com/projectdiscovery/notify/cmd/notify
	      echo 'source $GOPATH/src/github.com/tomnomnom/gf/gf-completion.bash' >> ~/.bashrc ;
	      cp -r $GOPATH/src/github.com/tomnomnom/gf/examples ~/.gf &>/dev/null && echo -e ${green} gf  "\xE2\x9C\x94" ${reset};
	      wget https://raw.githubusercontent.com/devanshbatham/ParamSpider/master/gf_profiles/potential.json -O /root/.gf/potential.json;

	      git clone https://github.com/1ndianl33t/Gf-Patterns /tmp/pattern &>/dev/null ; mv -f /tmp/pattern/*.json /root/.gf/ &>/dev/null ; rm -rf /tmp/pattern/ &>/dev/null && echo -e ${green} Gf-pattern  "\xE2\x9C\x94" ${reset};
	      go get -u github.com/dwisiswant0/hinject &>/dev/null && echo -e ${green} Hinject  "\xE2\x9C\x94" ${reset};
	      go get  github.com/hakluke/hakrawler   &>/dev/null && echo -e ${green} Hakrawler "\xE2\x9C\x94" ${reset};
	      go get -u github.com/tomnomnom/qsreplace &>/dev/null && echo -e ${green} qsreplace  "\xE2\x9C\x94" ${reset};
	      go get -u github.com/tomnomnom/assetfinder &>/dev/null && echo -e ${green} assetfinder  "\xE2\x9C\x94" ${reset};
	      go get -u github.com/tomnomnom/httprobe &>/dev/null && echo -e ${green} httprobe  "\xE2\x9C\x94" ${reset};
	      go get -u github.com/tomnomnom/unfurl &>/dev/null && echo -e ${green} unfurl  "\xE2\x9C\x94" ${reset};
	      go get github.com/haccer/subjack &>/dev/null && echo -e ${green} subjack  "\xE2\x9C\x94" ${reset};
	      export GO111MODULE=on && echo -e ${green} GO111MODILE ON "\xE2\x9C\x94" ${reset};
	      go get -u github.com/hahwul/dalfox &>/dev/null && echo -e ${green} delfox  "\xE2\x9C\x94" ${reset};
	      go get -v github.com/dwisiswant0/crlfuzz/cmd/crlfuzz &>/dev/null && echo -e ${green} crlfuzz  "\xE2\x9C\x94" ${reset};
	      go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder &>/dev/null && echo -e ${green} subfinder  "\xE2\x9C\x94" ${reset};
	      go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest &>/dev/null && echo -e ${green} httpx  "\xE2\x9C\x94" ${reset};
	      go get -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei &>/dev/null;
	      nuclei -update-templates &>/dev/null &>/dev/null && echo -e ${green} nuclei  "\xE2\x9C\x94" ${reset};
	      go get -u -v github.com/lc/subjs &>/dev/null && echo -e ${green} subjs  "\xE2\x9C\x94" ${reset};
          go install github.com/lc/gau/v2/cmd/gau@latest &>/dev/null && echo -e ${green} gau  "\xE2\x9C\x94" ${reset};
	      go get -v github.com/OWASP/Amass/v3/... &>/dev/null && echo -e ${green} Amass  "\xE2\x9C\x94" ${reset};
	      wget -q https://gist.githubusercontent.com/unkn-0wn/21bf8fe0468a30dced0d60fc48e8ffc1/raw/50111416548cbb0c77cf946b8a90d7ff23d303be/config.ini -O /root/.config/amass/config.conf &>/dev/null &&  echo -e ${green} amass.conf "\xE2\x9C\x94" ${reset};
	      go get -v github.com/projectdiscovery/naabu/v2/cmd/naabu &>/dev/null && echo -e ${green} Nabbu  "\xE2\x9C\x94" ${reset};
	      source $HOME/.bashrc && echo -e ${green} Sourced BashRc "\xE2\x9C\x94" ${reset};
	      echo ${green} Everything installed ... Ready to hack ${reset}
	      exit
