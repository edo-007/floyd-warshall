#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --error=err/test-mpi-omp.err
#SBATCH --output=out/test-mpi-omp.out
#SBATCH --mem=128000
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=16
#SBATCH --partition=skyvolta

module load devtoolset-9
module load cuda/10.2
module load openmpi

## nvc -O3 -fopenmp -mp=gpu -gpu=cc70 -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

make USE_OMP=y USE_MPI=y PRINT_D=n

ulimit -s $((10*1024*1024))

## il numero di processi è settato automaticamente in base a --ntask 
## echo "========================"
## echo "  #Tasks            :${SLURM_NTASKS}"
## echo "  #CPUS per task    :${SLURM_CPUS_PER_TASK}"
## echo "========================"


export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}

srun ./floyd-main
