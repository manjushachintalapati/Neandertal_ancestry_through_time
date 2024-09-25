#!/bin/sh
#SBATCH --job-name=getposterior
#SBATCH --cpus-per-task=1
#SBATCH --time=90:00:00
#SBATCH --account=<account>
#SBATCH --partition=<partion>

sample=$1
alpha=$2

module load gsl

par="${sample}_datecorrection.par"
echo "col:  1" >${par}
echo "l:  0.02" >>${par}
echo "h:  1.0" >>${par}
echo "inp: outfiles_${sample}/${sample}" >>${par}
echo "debug: 1" >>${par}
echo "alpha: ${alpha}" >>${par}
echo "output: outfiles_${sample}/${sample}.date_posterior" >>${par}
echo "print_interval: 10" >>${par}
echo "glb:    25" >>${par}
echo "gub:    33" >>${par}
echo "mcmc_iters: 1500" >>${par}
echo "burnin: 200" >>${par}
echo "fitaffine: 1" >>${par}
echo "seed:   1" >>${par}

~/dev/getposterior -p ${par}
