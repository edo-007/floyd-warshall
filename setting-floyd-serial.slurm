#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --error=err/test-serial.err
#SBATCH --output=out/test-serial.out
#SBATCH --nodes=1
#SBATCH --mem=128000
#SBATCH --cpu-freq=performance
#SBATCH --partition=skyvolta

module load devtoolset-9
module load cuda
## module load openmpi

## nvc -O3 -fopenmp -mp=gpu -gpu=cc70 -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

make PRINT_D=y
ulimit -s $((10*1024*1024))

srun ./floyd-main
