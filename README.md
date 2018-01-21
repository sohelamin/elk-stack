# ELK Stack

<p align="center">
    <img width="369" height="367" src="https://user-images.githubusercontent.com/1708683/35180071-ca7658bc-fdd1-11e7-87ea-3c55c037c501.png" alt="elk">
</p>

## Using on Linux

### Setup ELK stack on the main server
```
sudo chmod +x ELK.sh
./ELK.sh
```

### Setup Filebeat log shipper into client servers
```
sudo chmod +x filebeat.sh
./filebeat.sh
```

### Setup Metricbeat log shipper into client servers
```
sudo chmod +x metricbeat.sh
./metricbeat.sh
```

### Set `Filebeat` & `Metricbeat` output as logstash
```
#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["localhost:5044"]
  ssl.certificate_authorities: ["/etc/pki/tls/certs/logstash-forwarder.crt"]
```

## Setup on Docker

```
docker-compose up -d
curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_template/filebeat -d@kibana/filebeat.template.json
curl -XPUT -H 'Content-Type: application/json' http://localhost:9200/_template/metricbeat -d@kibana/metricbeat.template.json
```

## Extra commands

### Delete indices from Elasticsearch
```
curl -XDELETE 'http://localhost:9200/filebeat-*'
```

### Check the space usage in Elasticsearch
```
curl -XGET 'http://localhost:9200/_cat/indices?v'
```
