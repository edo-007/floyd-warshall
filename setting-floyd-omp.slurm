#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --error=err/test-omp.err
#SBATCH --output=out/test-omp.out
#SBATCH --mem=128000
#SBATCH --cpus-per-task=12
#SBATCH --cpu-freq=performance
#SBATCH --partition=skyvolta

module load cuda/10.2
module load nvhpc/22.11

## nvc -O3 -fopenmp -mp=gpu -gpu=cc70 -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

make USE_OMP=y USE_MPI=n PRINT_D=n

ulimit -s $((10*1024*1024))

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
srun ./floyd-main
