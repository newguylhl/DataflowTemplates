#! /bin/bash

set -E
set -u
set -e
set -o pipefail

# get current script dir
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Service Account Roles:
# Single Topic
#   Pub/Sub Publisher
#   DataCatalog EntryGroup Owner
# Multiple Topic
#   Pub/Sub Editor

# authenticate
export GOOGLE_APPLICATION_CREDENTIALS=ABSOLUTE_PATH/auth/test-debezium.json

PROPERTIES_PATH="${DIR}"
CONFIG_PATH="${PROPERTIES_PATH}/cdc_config.properties"
SECRET_PATH="${PROPERTIES_PATH}/cdc_secret.properties"

mvn -Pmysql exec:java -pl cdc-embedded-connector \
  -Dexec.args="${CONFIG_PATH} ${SECRET_PATH}" -X
