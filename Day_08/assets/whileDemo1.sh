#! /usr/bin/env bash

i=0
while (( i < 10 )) 
do
	(( i++ ))
	if [ $i -eq 5 ]; then
		continue # die 5 wird nicht ausgegeben
	fi
	echo "Zahl: $i"
done
