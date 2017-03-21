# aws-mongo-backups

### Run Mongo Database
docker run -d --name <mongo_container_name> -p 27017:271017 mongo

### Run S3 Mongo Backups
docker run -d --link <mongo_container_name>:mongo <br />
  -e MONGO_DB=<mongo_database_name> <br />
  -e S3_BUCKET=<S3_bucket_name> <br />
  -e AWS_ACCESS_KEY_ID=<S3_key> <br />
  -e AWS_SECRET_ACCESS_KEY=<S3_Secret> <br />
  --name <backups_container_name> raydavis/aws-mongo-backups
#### Optional
-e BACKUP_INTERVAL=<days_between_backups> <br />
-e BACKUP_TIME=<time_when_backup_will_run> ex: (2:00 <- 2AM or 14:00 <- 2PM)

### List backups on S3 Bucket
docker exec <backup_container_name> /app/list.sh

### Restore Mongo using backup from S3 Bucket
docker exec <backup_container_name> /app/restore.sh <backup_filename_as_display_from_list.sh>
