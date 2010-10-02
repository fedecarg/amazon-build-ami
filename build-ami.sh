#!/bin/bash

# Build AMI
# Federico Cargnelutti <fedecarg@gmail.com>

export EC2_DIR=/root/.ec2 
export EC2_HOME=$EC2_DIR/api/ec2-api-tools-1.3

export EC2_IMGNAME=example-ami-name
export EC2_BUCKET=s3-bucket-name
export EC2_ACCOUNT=0000
export EC2_ACCESS_KEY_ID=0000
export EC2_SECRET_ACCESS_KEY=0000
export EC2_PRIVATE_KEY=filename.pem
export EC2_CERT=filename.pem
export EC2_PLAT=i386

if [ "${EC2_IMGNAME}" != "" ]; then
    echo "Removing ${EC2_IMGNAME} files in $(pwd)..."
    rm -Rf /mnt/${EC2_IMGNAME}*
fi

echo "Creating AMI in $(pwd): ec2-bundle-vol..."
ec2-bundle-vol -d /mnt -k ${EC2_PRIVATE_KEY} -c ${EC2_CERT} \
    -u $EC2_ACCOUNT \
    -r $EC2_PLAT -p $EC2_IMGNAME

if [ $? -gt 0 ]; then
    echo "ec2-bundle-vol returned errors"
    exit 1
fi

echo "Uploading AMI to S3: ec2-upload-bundle..."
ec2-upload-bundle -b $EC2_BUCKET \
    -m /mnt/${EC2_IMGNAME}.manifest.xml \
    -a $EC2_ACCESS_KEY_ID \
    -s $EC2_SECRET_ACCESS_KEY

echo "Don't forget to register the image for AMI consumption: ec2-register..."
echo "ec2-register -K \$EC2_PRIVATE_KEY -C \$EC2_CERT \$EC2_BUCKET/${EC2_IMGNAME}.manifest.xml"

echo "Done"
exit 0
