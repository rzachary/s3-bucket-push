#!/bin/bash

set -e

# check to see the AWS_REGION is set if not set it to the Default us-east-1
if [ -z "$AWS_REGION" ]; then
  AWS_REGION="us-east-1"
fi

# check to see if the S3_BUCKET Environment variable is set, quit if it is not set
if [ -z "$AWS_S3_BUCKET" ]; then
  echo "AWS_S3_BUCKET is not set. Quitting."
  exit 1
fi

# check to see if the AWS ACCESS KEY is set, quit if it is not set
if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "AWS_ACCESS_KEY_ID is not set. Quitting."
  exit 1
fi

# check to see if the AWS ACCESS SECRET KEY is set
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_SECRET_ACCESS_KEY is not set. Quitting."
  exit 1
fi

# Override default AWS endpoint if user sets AWS_S3_ENDPOINT.
if [ -n "$AWS_S3_ENDPOINT" ]; then
  ENDPOINT_APPEND="--endpoint-url $AWS_S3_ENDPOINT"
fi

# create a temporary aws profile to run the command 
aws configure --profile s3-bucket-push <<-EOF > /dev/null 2>&1
${AWS_ACCESS_KEY_ID}
${AWS_SECRET_ACCESS_KEY}
${AWS_REGION}
text
EOF

# Sync using our dedicated profile and suppress verbose messages.
# All other flags are optional via the `args:` directive.
sh -c "aws s3 sync ${SOURCE_DIR:-.} s3://${AWS_S3_BUCKET}/${DEST_DIR} \
              --profile s3-sync-action \
              --no-progress \
              ${ENDPOINT_APPEND} $*"


aws configure --profile s3-bucket-push <<-EOF > /dev/null 2>&1
null
null
null
text
EOF