#! /bin/bash

set -E
set -u
set -e
set -o pipefail

# get current script dir
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Service Account Roles:
# Storage Object Viewer
# Pub/Sub Viewer
# Dataflow Admin
# Service Account User

# authenticate
export GOOGLE_APPLICATION_CREDENTIALS=ABSOLUTE_PATH/auth/test-debezium.json

# environment
JOB_NAME="cdc-mysql-to-bigquery"
PROJECT="GCP_PROJECT"
REGION="us-central1"
# SUBSCRIPTION="test_debezium_subscription"
SUBSCRIPTION="test_dbz_uat_mysql.data_analyze.gca_model-sub,test_dbz_uat_mysql.data_analyze.business-sub"
UPDATE_FREQUENCY_SECOND="100"
# CHANGELOG_BQ_DATASET="test_debezium_changelog"
# REPLICA_BQ_DATASET="test_debezium_replica"
CHANGELOG_BQ_DATASET="test_debezium_changelog_multi"
REPLICA_BQ_DATASET="test_debezium_replica_multi"
GCP_TEMP_LOCATION="gs://GCS_BUCKET/temp"
WORKER_MACHINE_TYPE="n1-standard-1"
MAX_NUM_WORKERS="2"

mvn exec:java -pl cdc-change-applier -Dexec.args="--runner=DataflowRunner \
  --useSingleTopic=false \
  --inputSubscriptions=${SUBSCRIPTION} \
  --updateFrequencySecs=${UPDATE_FREQUENCY_SECOND} \
  --changeLogDataset=${CHANGELOG_BQ_DATASET} \
  --replicaDataset=${REPLICA_BQ_DATASET} \
  --jobName=${JOB_NAME} \
  --project=${PROJECT} \
  --region=${REGION} \
  --workerMachineType=${WORKER_MACHINE_TYPE} \
  --maxNumWorkers=${MAX_NUM_WORKERS} \
  --gcpTempLocation=${GCP_TEMP_LOCATION} \
  --enableStreamingEngine"
