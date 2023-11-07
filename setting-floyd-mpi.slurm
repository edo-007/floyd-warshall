#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --output=out/test-mpi-8.out
#SBATCH --error=err/test-mpi.err
#SBATCH --mem=128000
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --cpu-freq=performance
#SBATCH --partition=skyvolta

module load cuda/10.2
module load openmpi
module load nvhpc/22.11

## nvc -O3 -fopenmp -mp=gpu -gpu=cc70 -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

make USE_MPI=y 

ulimit -s $((10*1024*1024))

# il numero di processi è settato automaticamente in base a --ntask
mpirun ./floyd-main
