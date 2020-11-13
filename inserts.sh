#!/bin/bash
set -euo pipefail
if [ $# -ne 5 ]
then
    echo "Usage: inserts.sh [hostname] [cassUsername] [cassPassword] [namespace] [sleepSeconds]"
    exit 2
fi
HOST=$1
USERNAME=$2
PASSWORD=$3
NAMESPACE=$4
SLEEPTIME=$5

AUTH_TOKEN=$(curl -vvv $HOST:8081/v1/auth -H "Content-type: application/json" -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}" | cut -c15-50)
echo $AUTH_TOKEN
curl -XPOST $HOST:8082/v2/schemas/namespaces -H "Content-type: application/json" -H "X-Cassandra-Token: $AUTH_TOKEN" -d "{\"name\": \"$NAMESPACE\"}"

idx=1
while [ true ]
do
  RAND=$(((RANDOM%20)))
  JSON=$(python jsongen.py $RAND $RAND 1)
  echo "Writing $JSON"
  curl -XPUT "$HOST:8082/v2/namespaces/$NAMESPACE/collections/collection/$idx"\
    -H "Content-type: application/json" -H "X-Cassandra-Token: $AUTH_TOKEN" -d "$JSON" & > /dev/null
  sleep $SLEEPTIME
  ((idx++))
done
