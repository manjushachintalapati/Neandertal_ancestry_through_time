## Detection of high frequency archaic ancestry regions
----------------------------------------------------------------------------------------------------------------
We analysed the genomes of 45 Early modern humans (EMH) and 101 present-day (SGDP) samples to infer regions which are high archaic frequency regions (potentially under selection).
The input data is posterior probability from Admixfrog in windows of 0.005cM across the genome. 
The example file is in the folder bindata_EUR_perCHR. Here the bins which have a posterior probability less than 0.8 are set to 0. 

To identify regions under putative selection, we use Z-scores to filter and rank the regions. Firstly, we compute mean in each bin across EMH and PP samples cohort separetly. 
Secondly, we compute a genome wide mean and SD. Third we compute Z-score in each bin using mean in a bin and genome wide mean and SD. Refere to the publication to more details. 
The scripts for computing these metrics along with final results are in the folder- summarystats

We grouped the high archaic frequency regions in three categories: 
i) regions that are at high frequency (Z > 4.5) in both EMH and PP samples. 
ii) regions that are at high frequency in PP individuals (Z > 4.5) but not in EMH individuals (Z < 1). 
iii) regions that are at high frequency in ancient individuals (Z > 4.5) but not in present-day individuals (Z < 1). 
The folder selected_regions contains scripts to infer theses regions and gene annotations as well.

