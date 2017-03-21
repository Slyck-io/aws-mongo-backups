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

if [ -n "$1" ]; then
        echo "Downloading backup from s3 bucket..."
        aws s3api get-object --bucket ${S3_BUCKET} --key $1 backup.tar.gz
        echo "Creating restore-backup folder..."
        mkdir -p restore-backup
        echo "Unzipping backup tar..."
        tar xvzf backup.tar.gz -C /restore-backup
        echo "Restoring to linked mongo databaser..."
        mongorestore --host ${MONGO_HOST} --port ${MONGO_PORT} /restore-backup/dump
        echo "Cleaning up folders and tar..."
        rm -rf backup.tar.gz
        rm -rf /restore-backup
        echo "Mongo Database Restored"
else
        echo "Please supple file from s3 you want to restore from. (use list.sh to view backups on the s3)"
        exit
fi
