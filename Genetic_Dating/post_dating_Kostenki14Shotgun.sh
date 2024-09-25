#!/bin/sh
#SBATCH --job-name=N_Kostenki14Shotgun  # The job name.
#SBATCH --cpus-per-task=2       # The number of cpu cores to use per task
#SBATCH --time=4:00:00         # The time the job will take to run.
#SBATCH --partition=<partion>
#SBATCH --account=<account>

# load required modules
module load r
module load python/3.7
module load gsl

#command lines
echo "1. dating"
~/dev/Neanderthal_dating/bin/neanderthal_dating -p parfile_Ndating_Kostenki14Shotgun
wait
mkdir -p outfiles_Kostenki14Shotgun
mv Kostenki14Shotgun* outfiles_Kostenki14Shotgun/
echo "2. Fitting exponential"
Rscript ~/dev/Neanderthal_dating/rexpfit.r outfiles_Kostenki14Shotgun/Kostenki14Shotgun  Kostenki14Shotgun_exp 2 0.02 1 TRUE TRUE TRUE
wait
mv Kostenki14Shotgun_exp.* fit_Kostenki14Shotgun_exp outfiles_Kostenki14Shotgun/
echo "3. Error correct the dates using dating get_posterior"
bash post_geneticMapcorrection.sh Kostenki14Shotgun genetic_maps_corrections/alpha.txt
