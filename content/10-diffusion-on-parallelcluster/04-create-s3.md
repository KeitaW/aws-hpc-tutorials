# Create S3 bucket

```
# generate a unique postfix
export BUCKET_POSTFIX=$(uuidgen --random | cut -d'-' -f1)
echo "Your bucket name will be sd-workshop-${BUCKET_POSTFIX}"
aws s3 mb s3://sd-workshop-${BUCKET_POSTFIX}
```


```
cat > post-install.sh << EOF

#!/bin/bash

CUDA_DIRECTORY=/usr/local/cuda
EFA_DIRECTORY=/opt/amazon/efa
OPENMPI_DIRECTORY=/opt/amazon/openmpi
STABLE_DIFFUSION_DIR=/shared/stable-diffusion

pip install 
if [ ! -d "\$FAIRSEQ_DIRECTORY" ]; then
    # control will enter here if $DIRECTORY doesn't exist.
    echo "Stable diffusion repository not found. Installing..."
    git clone https://github.com/justinpinkney/stable-diffusion.git \$STABLE_DIFFUSION_DIR
    pip install -e \$FAIRSEQ_DIRECTORY -U
    pip install boto3 tqdm -y
fi


chown -R ec2-user:ec2-user /lustre
chown -R ec2-user:ec2-user /shared

EOF

# upload to your bucket
aws s3 cp post-install.sh s3://mlbucket-${BUCKET_POSTFIX}/post-install.sh

# delete local copies
rm -rf post-install.sh
```