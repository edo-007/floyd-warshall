#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --error=err/test-target.err
#SBATCH --output=out/test-target.out
#SBATCH --gres=gpu:v100:1
#SBATCH --cpus-per-task=8
#SBATCH --cpu-freq=performance
#SBATCH --partition=skyvolta
#SBATCH --nodelist=node06

module load devtoolset-10
module load nvhpc/22.11

## nvc -O3 -fopenmp -mp=gpu -gpu=cc70 -o floyd-main floyd-main.o lib/floyd-library.o lib/time-library.o

make USE_OMP_TARGET=y 
## PRINT_D=y

ulimit -s $((10*1024*1024))

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
## nvprof --print-gpu-summary ./floyd-main
srun ./floyd-main
