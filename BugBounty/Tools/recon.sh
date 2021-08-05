                                                                                                   
#!/bin/bash
echo '
/ ___/_________  _________  (_)___ _____ 
  \__ \/ ___/ __ \/ ___/ __ \/ / __ `/ __ \
 ___/ / /__/ /_/ / /  / /_/ / / /_/ / / / /
/____/\___/\____/_/  / .___/_/\__,_/_/ /_/ 
                    /_/                    
'
echo  ' Automated with <3 by Hack2Death'

dir=~/arsenal 
red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

if [ $1 = "s" ]
then
  for url in $(cat $2); do
     echo '_____________________________________________'
     echo  "${red} Testing : ${green} ${url} ${reset}"
     echo '---------------------------------------------'
     echo '_________________________________________________________'
     echo  "${red} Performing : ${green} Small Scope Recon ${reset}"
     echo '---------------------------------------------------------'
     $dir/smallscope.sh $url;   
  done
fi


