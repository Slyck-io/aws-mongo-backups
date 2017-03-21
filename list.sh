#!/bin/bash

set -e

: ${MONGO_DB:?}
: ${S3_BUCKET:?}
: ${AWS_ACCESS_KEY_ID:?}
: ${AWS_SECRET_ACCESS_KEY:?}
: ${DATE_FORMAT:?}
: ${FILE_PREFIX:?}

MONGO_HOST=${MONGO_PORT_27017_TCP_ADDR:?}
MONGO_PORT=${MONGO_PORT_27017_TCP_PORT:?}

aws s3api list-objects --bucket ${S3_BUCKET} --prefix 'mongo-backups/' --output table --query 'Contents[].{FileName: Key, Size: Size, LastModified: LastModified}'
