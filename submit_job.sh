#!/bin/bash
#SBATCH -N 1
#SBATCH -C 'gpu&hbm80g'
#SBATCH -q regular
#SBATCH -J HENS_test
#SBATCH --mail-user=jmelms@iu.edu
#SBATCH --mail-type=ALL
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -o job_logs/%j.out

# Your existing srun command with the selected date
srun -u shifter --image=amahesh19/modulus-makani:0.1.0-torch_patch-23.11-multicheckpoint --module=gpu,nccl-2.18 --env=PYTHONUSERBASE=/global/homes/j/joshelms/supplemental_packages/pydantic_supplement_modulus-makani:0.1.0-torch_patch-23.11-multicheckpoint bash -c "source set_74ch_vars.sh; python -m earth2mip.inference_ensemble configs/test_n1.json"
# srun -u shifter --image=amahesh19/modulus-makani:0.1.0-torch_patch-23.11-multicheckpoint --module=gpu,nccl-2.18 bash -c "source set_74ch_vars.sh; pip list; python -m earth2mip.inference_ensemble configs/test_n1.json"