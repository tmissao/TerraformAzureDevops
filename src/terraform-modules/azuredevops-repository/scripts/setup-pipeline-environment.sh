#! /bin/bash -e

BASE_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis"
ENV_DESCRIPTION="$ENV_NAME environment"
API_VERSION="api-version=6.0-preview.1"
REVIEWER_GROUP=($(echo $REVIEWER_GROUPS | tr "," "\n"))

RESULT=$(curl -s -X POST "$BASE_URL/distributedtask/environments?$API_VERSION" \
    -H "Content-Type: application/json" \
    -u null:$TOKEN \
    --data @<(cat <<EOF
{
    "name": "$ENV_NAME",
    "description": "$ENV_DESCRIPTION"
}
EOF
)
)

ENV_ID=$(echo $RESULT | grep -o -E "\"id\":[0-9]+" | awk -F\: '{print $2}')

if [[ $REQUIRE_APPROVAL -eq 1 ]]; then
  APPROVERS=""
  
  for group in "${REVIEWER_GROUP[@]}"
  do
    APPROVERS+="{\"id\": \"$group\"},"
  done
  APPROVERS=${APPROVERS::-1}

curl -s -X POST "$BASE_URL/pipelines/checks/configurations?$API_VERSION" \
    -H "Content-Type: application/json" \
    -u null:$TOKEN \
    --data @<(cat <<EOF
{
  "type": {
    "id": "8C6F20A7-A545-4486-9777-F762FAFE0D4D",
    "name": "Approval"
  },
  "settings": {
    "approvers": [
      $APPROVERS
    ],
    "executionOrder": 1, 
    "instructions": "",
    "blockedApprovers": [],
    "minRequiredApprovers": ${#REVIEWER_GROUP[@]},  
    "requesterCannotBeApprover": false
  },
  "resource": {
    "type": "environment",
    "id": "$ENV_ID",
    "name": "$ENV_NAME"
  },
  "timeout": 43200
}
EOF
)
fi