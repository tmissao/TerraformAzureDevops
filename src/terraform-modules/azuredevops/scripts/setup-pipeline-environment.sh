#! /bin/bash

BASE_URL="https://dev.azure.com/$ORGANIZATION/$PROJECT/_apis"
ENV_DESCRIPTION="$ENV_NAME environment"

RESULT=$(curl -s -X POST "$BASE_URL/distributedtask/environments?api-version=6.0-preview.1" \
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

echo $REQUIRE_APPROVAL

if [[ $REQUIRE_APPROVAL -eq 1 ]]; then
curl -s -X POST "$BASE_URL/pipelines/checks/configurations?api-version=6.0-preview.1" \
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
      {
        "id": "$REVIEWER_GROUP"
      }
    ],
    "executionOrder": 1, 
    "instructions": "",
    "blockedApprovers": [],
    "minRequiredApprovers": 1,  
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