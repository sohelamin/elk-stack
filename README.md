# ELK Stack

## Installation

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

### Delete indices from Elasticsearch
```
curl -XDELETE 'http://localhost:9200/filebeat-*'
```

### Check the space usage in Elasticsearch
```
curl -XGET 'http://localhost:9200/_cat/indices?v'
```
