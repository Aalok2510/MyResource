                                                                                                   
#!/bin/bash

dir=/home/hack2death/arsenal 
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
     echo  "${red} Performing : ${green} Finding Links,Broken Links and Parameter ${reset}"
     echo '---------------------------------------------------------'
     $dir/linkparambroken.sh $url;
     echo '______________________________________________________________________'
     echo  "${red} Performing : ${green}  secretFinding ${reset}"
     echo '----------------------------------------------------------------------'      
     $dir/getsec.sh  $url;
     echo '______________________________________________________________________'
     echo  "${red} Performing : ${green} Finding urls and potential parameter ${reset}"
     echo '----------------------------------------------------------------------'
     $dir/extractor.sh $url;
     echo '______________________________________________________________________'
     echo  "${red} Performing : ${green} Directory BruteForce ${reset}"
     echo '----------------------------------------------------------------------'      
     $dir/ffuf.sh $url;
     echo '_____________________________________________'
     echo  "${red} Finished Testing : ${green} ${url} ${reset}"
     echo '---------------------------------------------'
  done
fi




