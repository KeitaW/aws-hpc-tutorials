Use Dreambooth example
# Finutune stabe-diffusion model with Diffusers
```
cd /lustre
cat > finetune.sh << EOF
#!/bin/bash
export MODEL_NAME="CompVis/stable-diffusion-v1-4"
export INSTANCE_DIR="/lustre/sample-images"
export OUTPUT_DIR="/lustre/log"

accelerate launch train_dreambooth.py \
  --pretrained_model_name_or_path=$MODEL_NAME  \
  --instance_data_dir=$INSTANCE_DIR \
  --output_dir=$OUTPUT_DIR \
  --instance_prompt="a photo of sks dog" \
  --resolution=512 \
  --train_batch_size=1 \
  --gradient_accumulation_steps=1 \
  --learning_rate=5e-6 \
  --lr_scheduler="constant" \
  --lr_warmup_steps=0 \
  --max_train_steps=400
EOF
chmod +x finetune.sh

cd /lustre

cat > job-finetune.slurm << EOF
#SBATCH --wait-all-nodes=1
#SBATCH --gres=gpu:1
#SBATCH --nodes=1
#SBATCH --cpus-per-task=48
#SBATCH --ntasks-per-node=1
#SBATCH --exclusive
#SBATCH -o out_%j.log
#SBATCH -e err_%j.log
srun /lustre/finetune.sh
EOF
sbatch job-finetune.slurm
```

## Ideas for resource viewing
* wandb
* ssh tunnel + web-ui
* https://docs.streamlit.io/knowledge-base/tutorials/databases/aws-s3
* mount Lustre on headnode then streamlit