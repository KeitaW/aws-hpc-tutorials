# Create Cluster Configuration File
This section assumes that you are familiar with AWS ParallelCluster and the process of bootstrapping a cluster.

Let us reuse the SSH key-pair created earlier.

The cluster configuration that you generate for training large scale ML models includes constructs from EFA and FSx that you can explore in the previous sections of this workshop. The main additions to the cluster configuration script are:

Set the compute nodes as p4d.24xlarge instances. The p4.24xlarge is one of the EFA supported instance types with multiple GPUs.
Set the cluster initial size to 0 compute nodes and maximum size to 4 instances. The cluster uses Auto Scaling Groups that will grow and shrink between the min and max limits based on the cluster utilization and job queue backlog.
Set the custom actions install script URL to the S3 path with the Conda configuration script. Also, you need to specify that ParallelCluster has access to this S3 bucket. Add following to the config:

keypair:
https://www.hpcworkshops.com/03-parallel-cluster-cli/05-key-pair-create.html



