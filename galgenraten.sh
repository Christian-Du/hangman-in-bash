#!/bin/bash
clear # clean screen

##############################
# Initialisierung des Spiels #
##############################

echo "Spieler 1 gib das Wort ein, das dein Mitspieler erraten soll.
Achte darauf, dass dein Mitspieler nicht schummelt ;)
Welches Wort soll erraten werden:"

read wort

wort=${wort^^} # to upper case

len=${#wort} # len wort

declare -a arr_ltrs=() # arry for letters
declare -a arr_lsg=() # arry for Lösung

for (( i=0 ; i<$len ; i++ )); do
  #echo ${wort:$i:1}
  arr_ltrs+=("${wort:$i:1}")
  arr_lsg+=("_")
done

#########################
# main loop of the game #
#########################

# initialisieren der Variablen für den main loop

play_count=10 
loesungsversuch=false
gewonnen=false
declare -a arr_geraten=() # array for guessed letters

while [[ $loesungsversuch == false && $gewonnen == false && $play_count > 0 ]]; do # vgl von mehreren Variablen ...
	clear
	echo "Du hast noch $play_count Versuche und hast schon folgende Buchstaben geraten:"
	echo ${arr_geraten[@]}
	echo "und folgende Buchstaben sind schon gelöst:"
	echo ${arr_lsg[@]}
	echo "welchen Buchstaben möchtest du als nächstes raten?"
	read buchstabe
	buchstabe=${buchstabe^^}; [[ "$buchstabe" == 42 ]] && gewonnen=true
	arr_geraten+=$buchstabe
	falsch_geraten=true
	for (( i=0 ; i<len ; i++)); do
		if [ "${wort:$i:1}" = "$buchstabe" ]; then
			echo "match gefunden"
			arr_lsg[$i]=$buchstabe
			falsch_geraten=false
		fi
	done

	if [[ ${arr_lsg[@]} == ${arr_ltrs[@]} ]]; then	#[[ == ]] da so auf gleiche patterns geprüft wird
		gewonnen=true
	fi
	
	if $falsch_geraten ; then
		play_count=$(($play_count-1))
	fi
	
	if [[ $gewonnen == false ]]; then	
		clear
		echo "Du hast noch $play_count Versuche und hast schon folgende Buchstaben geraten:"
		echo ${arr_geraten[@]}
		echo "und folgende Buchstaben sind schon gelöst:"
		echo ${arr_lsg[@]}
		echo "möchstest du das ganze Wort erraten?"
		echo "Wenn Ja, gib jetzt das Wort ein,"
		echo "wenn nein drücke Enter zum fortfahren."
		read lsg_wort
		lsg_wort=${lsg_wort^^}
		len_lsg_wort=${#lsg_wort}
		if [[ $len_lsg_wort > 0 && $lsg_wort == $wort ]]; then
			gewonnen=true
			break
		elif [[ $len_lsg_wort > 0 ]]; then
			loesungsversuch=true
			break
		fi 
	fi
done

clear

if $gewonnen ; then
	echo "Herzlichen Glückwunsch!
	du hast $wort richtig erraten, du hast gewonnen."
else
	echo "Schade, du hast '$wort' nicht erraten."
fi


