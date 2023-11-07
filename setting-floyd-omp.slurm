#!/bin/bash
#SBATCH --job-name=floyd-warshall
#SBATCH --output=out/test-omp.out
#SBATCH --error=err/test-omp.err
#SBATCH --mem=128000
#SBATCH --cpus-per-task=1
#SBATCH --cpu-freq=performance
#SBATCH --partition=skyvolta

module load cuda/10.2
module load nvhpc/22.11

make USE_OMP=y

ulimit -s $((10*1024*1024))

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
echo ${SLURM_CPUS_PER_TASK}
srun ./floyd-main
