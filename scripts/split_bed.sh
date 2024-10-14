#!/bin/bash
 
echo ${2} | tr ' ' '\n' |  while read chr
do
	
	echo ${1} | tr ' ' '\n' |while read fname
	do 
		zcat ${fname} | awk '{if ($1==${chr}) print $0 }' >> splitted/{sample}_${chr}.bed 
	done
done

