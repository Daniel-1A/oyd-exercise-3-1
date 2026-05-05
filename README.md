# oyd-exercise-3-1
## Evidence

### Instance info

\```

-------------------------------------------------------
|                  DescribeInstances                  |
+---------------------+--------------+----------------+
|  i-01e22a59a47fb48b2|  running     |  54.203.135.5  |
|  i-0a1558492422dc930|  terminated  |  None          |
|  i-0f3cb50bae75b926f|  terminated  |  None          |
+---------------------+--------------+----------------+

\```

### Health check

\```
curl.exe http://54.203.135.5:8080/health
{"status":"ok","compute":"ec2"}
\```

### Echo endpoint

\```
curl.exe -X POST http://54.203.135.5:8080/echo -H "Content-Type: application/json" -d '{\"msg\":\"hello\"}'
{"compute":"ec2","msg":"hello"}
\```