# ELK Stack

<p align="center">
    <img width="369" height="367" src="https://user-images.githubusercontent.com/1708683/35180071-ca7658bc-fdd1-11e7-87ea-3c55c037c501.png" alt="elk">
</p>

## Using Linux
1. Run the script.
  ```
  sudo chmod +x ELK.sh
  ./ELK.sh
  ```
2. Setup beat clients (eg. Filebeat) to your application server.
  ```
  sudo chmod +x filebeat.sh
  ./filebeat.sh
  ```
3. Configure beat clients (eg. filebeat) output as logstash.
  ```
  #----------------------------- Logstash output --------------------------------
  output.logstash:
    # The Logstash hosts
    hosts: ["localhost:5044"]
  ```
4. Create `filebeat-*` index pattern in kibana dashboard.

## Using Docker
1. Up the stack using `docker-compose` command.
    ```
    docker-compose up -d
    ```
2. Setup beat clients (eg. Filebeat) to your application server.
  ```
  sudo chmod +x filebeat.sh
  ./filebeat.sh
  ```
3. Configure beat clients (eg. filebeat) output as logstash.
  ```
  #----------------------------- Logstash output --------------------------------
  output.logstash:
    # The Logstash hosts
    hosts: ["localhost:5044"]
  ```
4. Create `filebeat-*` index pattern in kibana dashboard.

### Security
To protect the kibana dashboard you can use the `htpasswd` in nginx.
Disallow to access directly the port 9200, 5601, 5044 and use ssl authentication while communicating with logstash.

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
