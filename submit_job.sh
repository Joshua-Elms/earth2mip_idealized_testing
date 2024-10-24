#!/bin/bash
#SBATCH -N 1
#SBATCH -C 'cpu'
#SBATCH -q regular
#SBATCH -J HENS_test
#SBATCH --mail-user=jmelms@iu.edu
#SBATCH --mail-type=ALL
#SBATCH -t 00:30:00
#SBATCH -A m1517
#SBATCH -o job_logs/%j.out

# Your existing srun command with the selected date
export MODEL_REGISTRY="/global/cfs/cdirs/m1517/cascade/joshelms/fcn_model_registry/sfno_74ch/sfno_linear_74chq_sc2_layers8_edim620_wstgl2-epoch70_seed102"
srun -u shifter --image=amahesh19/modulus-makani:0.1.0-torch_patch-23.11-multicheckpoint --module=gpu,nccl-2.18 bash -c "source set_74ch_vars.sh; python -m earth2mip.inference_ensemble configs/test_n1.json"