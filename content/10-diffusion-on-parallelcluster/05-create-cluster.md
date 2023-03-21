# Create Cluster Configuration File
This section assumes that you are familiar with AWS ParallelCluster and the process of bootstrapping a cluster.

Let us reuse the SSH key-pair created earlier.

The cluster configuration that you generate for training large scale ML models includes constructs from EFA and FSx that you can explore in the previous sections of this workshop. The main additions to the cluster configuration script are:

Set the compute nodes as p4d.24xlarge instances. The p4.24xlarge is one of the EFA supported instance types with multiple GPUs.
Set the cluster initial size to 0 compute nodes and maximum size to 4 instances. The cluster uses Auto Scaling Groups that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
Set the custom actions install script URL to the S3 path with the Conda configuration script. Also, you need to specify that ParallelCluster has access to this S3 bucket. Add following to the config:

keypair:
https://www.hpcworkshops.com/03-parallel-cluster-cli/05-key-pair-create.html

```
# create the cluster configuration
export IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
export SUBNET_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
export VPC_ID=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
export AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
export REGION=${AZ::-1}
```


```
cat > ml-config.yaml << EOF
Region: ${REGION}
Image:
  Os: alinux2
SharedStorage:
  - MountDir: /shared
    Name: default-ebs
    StorageType: Ebs

  - Name: fsxshared
    StorageType: FsxLustre
    MountDir: /lustre
    FsxLustreSettings:
      StorageCapacity: 1200
      ImportPath: s3://sd-workshop-${BUCKET_POSTFIX}
      DeploymentType: SCRATCH_2

HeadNode:
  InstanceType: c5n.2xlarge
  Networking:
    SubnetId: ${SUBNET_ID}
  Ssh:
    KeyName: ${AWS_KEYPAIR}
  Dcv:
    Enabled: true

Scheduling:
  Scheduler: slurm
  SlurmQueues:
    - Name: compute
      ComputeResources:
      - Name: p4d24xlarge
        InstanceType: p4d.24xlarge
        MinCount: 0
        MaxCount: 4
        DisableSimultaneousMultithreading: true
        Efa:
          Enabled: true
      CapacityType: SPOT
      CustomActions:
        OnNodeConfigured:
          Script: s3://sd-workshoop-${BUCKET_POSTFIX}/post-install.sh
      Iam:
        S3Access:
          - BucketName: sd-workshop-${BUCKET_POSTFIX}
      Networking:
        SubnetIds:
          - ${SUBNET_ID}
        PlacementGroup:
          Enabled: true
EOF

```