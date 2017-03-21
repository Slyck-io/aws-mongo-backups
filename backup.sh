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

FOLDER=/backup
DUMP_OUT=dump

FILE_NAME=${FILE_PREFIX}$(date -u +${DATE_FORMAT}).tar.gz

echo "Creating backup folder..."

rm -fr ${FOLDER} && mkdir -p ${FOLDER} && cd ${FOLDER}

echo "Starting backup..."

mongodump --host=${MONGO_HOST} --db=${MONGO_DB} --out=${DUMP_OUT} --quiet

echo "Compressing backup..."

tar -zcvf ${FILE_NAME} ${DUMP_OUT} && rm -fr ${DUMP_OUT}

echo "Uploading to S3..."

aws s3api put-object --bucket ${S3_BUCKET} --key mongo-backups/${FILE_NAME} --body ${FILE_NAME}

echo "Removing backup file..."

rm -f ${FILE_NAME}

echo "Done!"
