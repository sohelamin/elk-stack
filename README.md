
# ELK Stack

<p align="center">
    <img width="369" height="367" src="https://user-images.githubusercontent.com/1708683/35180071-ca7658bc-fdd1-11e7-87ea-3c55c037c501.png" alt="elk">
</p>

## Using Linux

### ELK Stack
Setup the main ELK Stack on a linux server using the shell script.
```
sudo chmod +x ELK.sh
./ELK.sh
```

### Clients (Filebeat, Metricbeat)
Once, you've done the setup of ELK Stack you should setup the beat clients eg. filebeat, metricbeat on the different server.
```
sudo chmod +x filebeat.sh
./filebeat.sh

sudo chmod +x metricbeat.sh
./metricbeat.sh
```

Now set the output of filebeat, metricbeat as logstash.
```
#----------------------------- Logstash output --------------------------------
output.logstash:
  # The Logstash hosts
  hosts: ["localhost:5044"]
  ssl.certificate_authorities: ["/etc/pki/tls/certs/logstash-forwarder.crt"]
```

## Using Docker
1. Up the stack using `docker-compose` command
    ```
    docker-compose up -d
    ```
2. Setup the beat clients (filebeat, metricbeat) as needed
3. Import the Kibana dashboard
    Go to `http://localhost:5601/` then, click `Management->Saved Objects->Import`  and import from the [kibana/dashboard.json](kibana/dashboard.json) file
4. Create index pattern as `filebeat-*` & `metricbeat-*`

### Security
To protect the kibana dashboard you can use the `htpasswd` in nginx.
Disallow to access directly the port 9200, 5601, 5044 over the web and use SSL certificates for the ELK & beat communication.

### Extra commands

Delete indices from Elasticsearch
```
curl -XDELETE 'http://localhost:9200/filebeat-*'
```
Check the space usage in Elasticsearch
```
curl -XGET 'http://localhost:9200/_cat/indices?v'
curl -XGET 'http://localhost:9200/_cat/allocation?v'
```

## Author

[Sohel Amin](http://sohelamin.com)

## License

This project is licensed under the MIT License - see the [License File](LICENSE) for details
