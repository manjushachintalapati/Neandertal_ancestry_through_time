#!/bin/bash
# Infer regions of high archaic ancestry in either EMH or PP samples
# Author: MC

# params and paths 
z_high=4.5 # got it as top 1% 
z_low=1 
outfile_summary=summary_stats
echo "Using the cut off's: Z-score high:${z_high}; Z-score low:${z_low}";

echo " Data for the EMH and PP"
paste <(cat ../summarystats/data_EMH_Zscore_Size) <(cat ../summarystats/data_PP_Zscore_Size) > Data_EMH_PP

echo "##### 1. Regions of constant N ancestry"
cat Data_EMH_PP | awk -v z_high="$z_high" '{if($4>z_high && $9>z_high) {print $0}}' | awk '{print $1"\t"$2-0.005"\t"$2"\t"$4}' | awk '{print $1"\t"$2*1000"\t"$3*1000"\t"$4}' | tail -n +2 > significant_constant_Nancestry.bed

bedtools merge -i significant_constant_Nancestry.bed | awk '{print $1"\t"$2/1000"\t"$3/1000}' | awk '{print $0"\t"$3-$2}' > constant_ancestry_bins.bed 

# get human coordinates based on the map avaialble from admixfrog
awk 'FNR==NR{a[$1"\t"$2]=$3;next} {if(a[$1"\t"$2]) { print $0"\t"a[$1"\t"$2]}}' bins_physicalSNP <(awk '{print $1"\t"$2"\n"$1"\t"$3}' constant_ancestry_bins.bed ) | paste - - | awk '{print $1"\t"$2"\t"$5"\t"$3"\t"$6}' > human_coordinates_constant_ancestry 

cut -f 1,4-5 human_coordinates_constant_ancestry > human_coordinates_constant_ancestry.bed

bedtools intersect -wo -a human_coordinates_constant_ancestry.bed -b /global/scratch/users/m_chintalapati/EMH/Dataset_EMH/human_annotation/havana_genecoordinates_names.bed > genes_constant_Nancestry

echo "##### 2. Regions of decreasing ancestry"
cat Data_EMH_PP | awk -v z_high="$z_high" -v z_low="$z_low" '{if($4>z_high && $9<z_low) {print $0}}' | awk '{print $1"\t"$2-0.005"\t"$2"\t"$4}' | awk '{print $1"\t"$2*1000"\t"$3*1000"\t"$4}' | tail -n +2 > significant_decrease_Nancestry.bed

bedtools merge -i significant_decrease_Nancestry.bed | awk '{print $1"\t"$2/1000"\t"$3/1000}' | awk '{print $0"\t"$3-$2}' > decrease_ancestry_bins.bed

awk 'FNR==NR{a[$1"\t"$2]=$3;next} {if(a[$1"\t"$2]) { print $0"\t"a[$1"\t"$2]}}' bins_physicalSNP <(awk '{print $1"\t"$2"\n"$1"\t"$3}' decrease_ancestry_bins.bed ) | paste - - | awk '{print $1"\t"$2"\t"$5"\t"$3"\t"$6}' > human_coordinates_decrease_ancestry

cut -f 1,4-5 human_coordinates_decrease_ancestry > human_coordinates_decrease_ancestry.bed

bedtools intersect -wo -a human_coordinates_decrease_ancestry.bed -b havana_genecoordinates_names.bed > genes_decrease_Nancestry

echo "##### 3. Regions of increasing ancestry"
cat Data_EMH_PP | awk -v z_high="$z_high" -v z_low="$z_low" '{if($4<z_low && $9>z_high) {print $0}}' | awk '{print $1"\t"$2-0.005"\t"$2"\t"$9}' | awk '{print $1"\t"$2*1000"\t"$3*1000"\t"$4}' | tail -n +2 > significant_increase_Nancestry.bed

bedtools merge -i significant_increase_Nancestry.bed | awk '{print $1"\t"$2/1000"\t"$3/1000}' | awk '{print $0"\t"$3-$2}' > increase_ancestry_bins.bed

awk 'FNR==NR{a[$1"\t"$2]=$3;next} {if(a[$1"\t"$2]) { print $0"\t"a[$1"\t"$2]}}' bins_physicalSNP <(awk '{print $1"\t"$2"\n"$1"\t"$3}' increase_ancestry_bins.bed ) | paste - - | awk '{print $1"\t"$2"\t"$5"\t"$3"\t"$6}' > human_coordinates_increase_ancestry

cut -f 1,4-5 human_coordinates_increase_ancestry > human_coordinates_increase_ancestry.bed

bedtools intersect -wo -a human_coordinates_increase_ancestry.bed -b havana_genecoordinates_names.bed > genes_increase_Nancestry

echo "##### Summary stats"
echo "Constant N ancestry" > ${outfile_summary}
echo "significant bins" >> ${outfile_summary}
cat significant_constant_Nancestry.bed | wc -l >> ${outfile_summary}
echo " regions" >> ${outfile_summary}
cat constant_ancestry_bins.bed | wc -l >> ${outfile_summary}
echo "genes" >> ${outfile_summary}
cat genes_constant_Nancestry | wc -l >> ${outfile_summary}

echo "Increase N ancestry" >> ${outfile_summary}
echo "significant bins" >> ${outfile_summary}
cat significant_increase_Nancestry.bed | wc -l >> ${outfile_summary}
echo " regions" >> ${outfile_summary}
cat increase_ancestry_bins.bed | wc -l >> ${outfile_summary}
echo "genes" >> ${outfile_summary}
cat genes_increase_Nancestry | wc -l >> ${outfile_summary}

echo "Decrease N ancestry" >> ${outfile_summary}
echo "significant bins" >> ${outfile_summary}
cat significant_decrease_Nancestry.bed | wc -l >> ${outfile_summary}
echo " regions" >> ${outfile_summary}
cat decrease_ancestry_bins.bed | wc -l >> ${outfile_summary}
echo "genes" >> ${outfile_summary}
cat genes_decrease_Nancestry | wc -l >> ${outfile_summary}

# checking for overlaps in published regions
awk '{print $0"\tincrease"}' human_coordinates_increase_ancestry.bed > list_selected_regions.bed
awk '{print $0"\tdecrease"}' human_coordinates_decrease_ancestry.bed >> list_selected_regions.bed
awk '{print $0"\tconstant"}' human_coordinates_constant_ancestry.bed >> list_selected_regions.bed

bedtools intersect -wo -a published_adaptive_regions.bed -b list_selected_regions.bed > overlap_published.bed 
echo "number of published regions overlaping the final list" >> ${outfile_summary}
bedtools intersect -wo -a published_adaptive_regions.bed -b list_selected_regions.bed | cut -f 1-3 | uniq | wc -l >> ${outfile_summary} 

echo "Analysis done- stats written to file:"${outfile_summary}

echo "merge the regions which are close together"
cat <(cut -f 1-3 human_coordinates_constant_ancestry |  awk '{print $0"\tconstant"}' ) <(cut -f 1-3 human_coordinates_increase_ancestry |  awk '{print $0"\tincrease"}') <(cut -f 1-3 human_coordinates_decrease_ancestry |  awk '{print $0"\tdecrease"}') > list_selected_bins
awk '{print $1"\t"($2-0.05)*1000"\t"($3+0.05)*1000"\t"$4}' list_selected_bins | sort -nk1 -nk2 > tmp_selected_bins.bed
bedtools merge -i tmp_selected_bins.bed > merged_selected_regions

awk 'FNR==NR{a[$1"\t"$2]=$0;next} {if(a[$1"\t"$2]) { print $0"\t"a[$1"\t"$2]} else {print $0} }' merged_selected_regions tmp_selected_bins.bed | awk '{print $1"\t"$2/1000+0.05"\t"$3/1000-0.05"\t"$4"\t"$5"\t"$6/1000+0.05"\t"$7/1000-0.05}' > list_merged_selected_regions.bed

awk 'FNR==NR{a[$1"\t"$2]=$3;next} {if(a[$5"\t"$6]) { print $0"\t"a[$5"\t"$6]}}' bins_physicalSNP list_merged_selected_regions.bed  | awk 'FNR==NR{a[$1"\t"$2]=$3;next} {if(a[$5"\t"$7]) { print $0"\t"a[$5"\t"$7]}}' bins_physicalSNP - > final_regions_before_reformat

awk '{print $1"\t"$6"\t"$7"\t"$4"\t"$8"\t"$9}' final_regions_before_reformat > final_selected_regions
echo "merged bins whihc are closer- final_selected_regions"
