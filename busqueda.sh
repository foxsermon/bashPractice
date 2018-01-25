#!/usr/bin/env bash
MY_PATH="`( cd \"$MY_PATH\" && pwd )`"
exMyPath=$MY_PATH'/'
reMyPath=' - '
counter=0
ic=0
array=( "svn-base" "wc.db" ".jar" ".class" ".war" "target" ".eot" ".ttf" ".tar")

toSearch=`find ${exMyPath} -type f`
i=1
sp="/-\|"
for file in ${toSearch}; do
	printf "\b${sp:i++%${#sp}:1}"
	if [ ! -z "$2" ]; then
		if ! [[ $file = *$2* ]]
		then
			continue
		fi
	fi

	if [ -d $file ] ; then
		continue		
	fi
	## Do not check .svn-base files	
	skipMe=false
	for iSkip in "${array[@]}"; do
		if [[ $file = *$iSkip* ]]
		then
			skipMe=true
		fi
	done
	if [ $skipMe = true ]; then
		continue
	fi	
	linenumber=0
	dos="////"
	uno="//"
	file=${file/$dos/$uno}
	if [[ $file = *$dos* ]]
	then
		echo "Je te trouve "$file
	fi	
    if (grep -q -s "$1" ${file}); then
		printf "\b$(tput setaf 10)${file/$exMyPath/$reMyPath}$(tput sgr0)"
    	printf '\n\n'

    	count=$(grep -c -s "$1" ${file})
    	let counter+=count

		old_IFS=$IFS      # save the field separator           
		IFS=$'\n'     # new field separator, the end of line           
		##echo "Antes $(date)"
		for line in $(cat ${file})       
		#while read line   
		do  
			##echo "Entro $(date)"
			if [ ${#line} -gt 10003 ] ; then
				printf "       \033[33;5;7mLinea numero ${linenumber} muy larga para mostrar, es de ${#line} caracteres.\033[0m" 
				printf "\n\n"
				continue
			fi
			let linenumber+=1
			if [[ $line = *$1* ]]
			then				
				let ic+=1
				salida=${line/$1/'\033[38;5;148m'$1'\033[39m'}
				printf "\b%4s -- $(tput setaf 14)%4s :=> $(tput sgr0) ${salida} \n" "${ic}" "${linenumber}" 
				##echo "${ic} => ${linenumber} : ${line}"
			   	if [ $((ic%15)) -eq 0 ]
			   	then
			   			echo "Appuyez sur Entrée pour continuer"
			   			#printf "\033[33;5mEnter\033[0m"
			   			#sleep .4
			   			#printf "\b\b\b\b\b"
			   			#printf "\033[33;5;7mEnter\033[0m"
			   			#sleep .4
			   			#printf "\b\b\b\b\b"
			   			read input
			   	fi
		   	fi
		#done < ${file}
	    done
		IFS=$old_IFS     # restore default field separator 
    	##for linea in `grep -inE --color=auto $1 ${file}`; do
    	##	array=${linea//:/}
    	##	echo ${array[0]}
    	##done
    	echo "-----------------------------------------------------------------"
    	printf '\n\n'
    fi
done
echo -e "\bString \033[38;5;148m[ \"$1\" ]\033[39m repeated: \x1B[35m${counter}\x1B[0m"
osascript -e 'display notification "String \"$1\" repeated ${counter} " with title "Busqueda Terminada $(date)"'
## Display colors
## for (( i = 0; i < 17; i++ )); 
##   do echo "$(tput setaf $i)This is ($i) $(tput sgr0)"; 
## done

## solo="Esta metrics salio muy bien"
## tem=${solo/$1/'\033[38;5;148m'$1'\033[39m'}
## echo -e "My favorite color is \033[38;5;148m Yellow-Green \033[39m"
## echo -e "${tem}"


##grep -inE $1 ${file} | while read -r line ; do
	##---STR_ARRAY=(`echo $line | tr ":" "\n"`)
	##---for x in "${STR_ARRAY[@]}"
	##---do
	##---	echo "&gt; [$x]"
	##---done						
##	arrIN=(${line//:/ })
	##---echo ${arrIN[0]}'  '${line/${arrIN[0]}':'/}
##	tempo=${line/${arrIN[0]}':'/}
##	salida=${tempo/$1/'\033[38;5;148m'$1'\033[39m'}
	##---echo -e "${salida}"
	##---echo "$(tput setaf 11)${arrIN[0]}$(tput sgr0) ==> ${line/${arrIN[0]}':'/}"
##	echo -e "$(tput setaf 14)${arrIN[0]}$(tput sgr0) ==> ${salida}"
##done