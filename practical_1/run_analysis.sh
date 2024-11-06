#!/bin/bash

#SBATCH --job-name=test_job
#SBATCH --partition=teach_cpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=0:10:00
#SBATCH --mem=100M
#SBATCH --account=SSCM033324

cd "${SLURM_SUBMIT_DIR}"

echo 'Setting up environment'

source ~/initMamba.sh

mamba activate ahds_week9

mkdir -p ../results
mkdir -p ../data/derived/

cd ../setup/

Rscript 0_get_conditions.R

echo 'Starting analysis'

cd ../code/

{       read
        while IFS=, read -r line;
        do
                Rscript 1_find_side_effects.R "${line}"
                Rscript 2_plot_wordcloud.R "${line}"
        done

}< ../data/derived/top_conditions.csv
