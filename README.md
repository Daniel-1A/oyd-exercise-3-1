# oyd-exercise-3-1
## Evidence

### Instance info

\```
(pega aquí el contenido de instance.txt)
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