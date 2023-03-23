## Create AMI

```
git clone https://github.com/aws-samples/parallelcluster-efa-gpu-preflight-ami.git && \
cd parallelcluster-efa-gpu-preflight-ami.git
git checkout mbp_packer-1.8.6_ansible-core-2.14.3
```


```
packer init .
```

Open `packer-ami.pkr.hcl`, and change the `aws_region` to the region where you want the AMI to be build and appera, the `aws_subnet` variable to one of the public subnets in the default VPC (or any other VPC of your choice). Also note that the `instance_type` is set to `g4dn.12xlarge`, so make sure the account has this limit configured.

Additionally, from a Cloud9 alinux2 instance, remove the last line in `packer-ami.pkr.hcl` which looks like `extra_arguments = [ "--scp-extra-args", "'-O'" ]`.

```
make ami_gpu
```

It will launch 

```
amazon-ebs.aws-pcluster-ami: output will be in this color.

==> amazon-ebs.aws-pcluster-ami: Prevalidating any provided VPC information
==> amazon-ebs.aws-pcluster-ami: Prevalidating AMI Name: pcluster-gpu-efa-1-20230321094011
    amazon-ebs.aws-pcluster-ami: Found Image ID: ami-0aa1d58c2de6b0447
==> amazon-ebs.aws-pcluster-ami: Creating temporary keypair: packer_64197b7b-54c8-5e11-016e-38029d249afb
==> amazon-ebs.aws-pcluster-ami: Creating temporary security group for this instance: packer_64197b7f-dc0d-ed38-5d60-8646592b5bea
==> amazon-ebs.aws-pcluster-ami: Authorizing access to port 22 from [0.0.0.0
==> amazon-ebs.aws-pcluster-ami: Waiting for instance (i-0a1d29a1b4413c061) to become ready...
...
==> amazon-ebs.aws-pcluster-ami: No volumes to clean up, skipping
==> amazon-ebs.aws-pcluster-ami: Deleting temporary security group...
==> amazon-ebs.aws-pcluster-ami: Deleting temporary keypair...
Build 'amazon-ebs.aws-pcluster-ami' finished after 22 minutes 39 seconds.

==> Wait completed after 22 minutes 39 seconds

==> Builds finished. The artifacts of successful builds are:
--> amazon-ebs.aws-pcluster-ami: AMIs were created:
ap-northeast-1: ami-017805b778e2c7557
```

```
pcluster build-image --image-id IMAGE_ID --image-configuration IMAGE_CONFIG.yaml --region REGION
{
 "image": {
   "imageId": "IMAGE_ID",
   "imageBuildStatus": "BUILD_IN_PROGRESS",
   "cloudformationStackStatus": "CREATE_IN_PROGRESS",
   "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:123456789012:stack/IMAGE_ID/abcd1234-ef56-gh78-ij90-1234abcd5678",
   "region": "us-east-1",
   "version": "3.5.0"
 }
}
```


```
pcluster build-image --image-id IMAGE_ID --image-configuration IMAGE_CONFIG.yaml --region REGION
    {
 "image": {
   "imageId": "IMAGE_ID",
   "imageBuildStatus": "BUILD_IN_PROGRESS",
   "cloudformationStackStatus": "CREATE_IN_PROGRESS",
   "cloudformationStackArn": "arn:aws:cloudformation:us-east-1:123456789012:stack/IMAGE_ID/abcd1234-ef56-gh78-ij90-1234abcd5678",
   "region": "us-east-1",
   "version": "3.5.0"
 }
}
```
