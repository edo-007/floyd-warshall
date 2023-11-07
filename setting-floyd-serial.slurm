#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --output=out/test-serial-nuse.out
#SBATCH --error=err/test-serial.err
#SBATCH --nodes=1
#SBATCH --mem=128000
#SBATCH --cpus-per-task=1
#SBATCH --cpu-freq=performance
#SBATCH --partition=skyvolta

module load devtoolset-9
module load cuda

## nvc -O3 -fopenmp -mp=gpu -gpu=cc70 -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

make ff=nuse PRINT_D=n
ulimit -s $((10*1024*1024))

srun ./floyd-main
