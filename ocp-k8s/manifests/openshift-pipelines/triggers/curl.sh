curl -X POST http://el-alertmanager-listener:8080 \
  -H 'Content-Type: application/json' \
  -d '{
    "receiver": "webhook",
    "status": "firing",
    "alerts": [
      {
        "status": "firing",
        "labels": {
          "alertname": "KubeJobFailed",
          "instance": "node-1.example.com"
        },
        "annotations": {
          "summary": "Job in openshift-image-registry failed. Go take a peek"
        },
        "startsAt": "2023-11-15T16:24:29.753Z",
        "endsAt": "0001-01-01T00:00:00Z"
      }
    ]
  }'
