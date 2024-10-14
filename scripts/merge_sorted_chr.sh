


#!/bin/bash


echo ${1} | tr ' ' '\n' | while read fname
do
	zcat $fname  | sort -k2,3 >> sorted_bed_file_per_sample/{sample}_sorted.bed 
	

done


