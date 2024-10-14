
import sys
import pandas as pd
run_df=pd.read_csv("data/run_metadata.tsv",sep="\t",header="infer")
sample_df=pd.read_csv("data/samples.tsv",sep="\t",header="infer")
std_sel_df=pd.read_csv("data/standard_selection.tsv",sep="\t",header="infer")
run_df.index=run_df["run"]
sample_df.index=sample_df["sample"]
def get_all_runs_for_a_sample(wildcards):
	all_runs=sample_df.loc[wildcards.sample,"runs"].split(",")
	run_path_list=[]
	
	for r in all_runs:
		p=run_df.loc[r,"file_path"]
		print(p)
		run_path_list.append(p)
	return run_path_list


chrom_selection=[]
for r in std_sel_df["Chromosome"]:
	chrom_selection.append(r)
	
rule splitting_bed_file:
	input:
		all_runs=lambda sample: get_all_runs_for_a_sample(sample),
		all_chr_list=chrom_selection
	output:
		all_chrom_files=expand("splitted/{{sample}}_{chrom}.bed",chrom=chrom_selection)
	shell:
		"sh scripts/split_bed.sh \"{input.all_runs}\" \"{input.all_chr_list}\"  \"{output.all_chrom_files}\" "

rule sorting_bed_file:
	input: 
		
		
		all_chrom_files=expand("splitted/{{sample}}_{chrom}.bed",chrom=chrom_selection)
		
		
	output:
		
		sorted_bed="sorted_bed_file_per_sample/{sample}_sorted.bed"
	shell:
		"sh scripts/merge_sorted_chr.sh \"{input.all_chrom_files}\"   {output.sorted_bed} "
		

	

