Prepare training script

```
cd /lustre
cat > train.sh << EOF
#!/bin/bash
# setup NCCL to use EFA
export FI_PROVIDER=efa
export FI_EFA_TX_MIN_CREDITS=64
export NCCL_DEBUG=INFO
export NCCL_TREE_THRESHOLD=0
export NCCL_SOCKET_IFNAME=eth0
export LD_LIBRARY_PATH=$HOME/nccl/build/lib:/usr/local/cuda/lib64:/opt/amazon/efa/lib64:/opt/amazon/openmpi/lib64:\$LD_LIBRARY_PATH


python main.py -t --base ../configs/stable-diffusion/pokemon.yaml --gpus 0,1,2,3,4,5,6,7  --scale_lr False \
       --num_nodes 4     --check_val_every_n_epoch 10    \
       --finetune_from /lustre/checkpoints/sd-v1-4-full-ema.ckpt  \
       --logdir /lustre/log \
       data.params.batch_size=4  \
       lightning.trainer.accumulate_grad_batches=1 \
       data.params.validation.params.n_gpus=8 

EOF
chmod +x train.sh

cd /lustre
cat > job.slurm << EOF
#!/bin/bash
#SBATCH --wait-all-nodes=1
#SBATCH --gres=gpu:8
#SBATCH --nodes=4
#SBATCH --cpus-per-task=48
#SBATCH --ntasks-per-node=1
#SBATCH --exclusive
#SBATCH -o out_%j.log
#SBATCH -e err_%j.log
srun /lustre/train.sh
EOF

cd /lustre
sbatch job.slurm
```

