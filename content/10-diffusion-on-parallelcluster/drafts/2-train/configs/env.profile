export AWS_KEYPAIR=keypair

export ACCOUNT_ID=$(aws sts get-caller-identity --output text --query Account)
export AWS_REGION=$(curl -s 169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')
export BUCKET_POSTFIX="${ACCOUNT_ID}-${AWS_REGION}"
# training data
export DataBucket="mlbucket-${BUCKET_POSTFIX}"
export DataBucketURI="s3://${DataBucket}"
export TrainDataURL="https://s3.amazonaws.com/research.metamind.io/wikitext/wikitext-103-v1.zip"
export TrainData="wikitext-103"
export TrainDataZip="wikitext-103-v1.zip"

# cluster configuration
export IFACE=$(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
export SUBNET_ID="subnet-05bdf1d356912d1bd" # $(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/subnet-id)
export VPC_ID="vpc-0386fb6496e4aff7d" # $(curl --silent http://169.254.169.254/latest/meta-data/network/interfaces/macs/${IFACE}/vpc-id)
export AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
export REGION=${AZ::-1}
export CLUSTER_NAME="ml-cluster"
