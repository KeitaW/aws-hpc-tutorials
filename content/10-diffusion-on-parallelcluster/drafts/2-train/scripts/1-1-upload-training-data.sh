#!/bin/bash
. .profile
cd /tmp

echo "Your bucket name will be ${DataBucket}"
aws s3 mb ${DataBucketURI}

wget ${TrainDataURL} -O ${TrainDataZip}
echo "Data downloaded as" ${TrainDataZip}
unzip ${TrainDataZip}

# upload to your bucket
aws s3 cp ${TrainData} ${DataBucketURI}/${TrainData} --recursive
# delete local copies
rm -rf ${TrainData} ${TrainDataZip}
