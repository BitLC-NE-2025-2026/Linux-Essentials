#! /usr/bin/env bash

while read LINE
do
	echo "--$LINE--" >> datLesen$(date +%m%d-%H%M).txt
done < $1
