#/bin/bash
echo -n "Enter ELK Server's IP or FQDN: "
read elkip
echo -n "Enter Kibana Admin Web Password: "
read kibanapassword

# Update & upgrade the system
sudo apt-get update
sudo apt-get upgrade -y

# Install java
sudo add-apt-repository ppa:webupd8team/java -y
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

# Add elasticsearch package source
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update

# Install elasticsearch
sudo apt-get install elasticsearch -y
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl restart elasticsearch.service

# Install kibana
sudo apt-get install kibana -y
sudo sed -i "s/#server.host: .*/server.host: localhost/" /etc/kibana/kibana.yml
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl restart kibana.service

# Install & configure nginx
sudo apt-get -y install nginx -y
cat <<EOC | sudo su
cat <<EOT > /etc/nginx/sites-available/default
server {
    listen 80;

    server_name $elkip;

    auth_basic "Restricted Access";
    auth_basic_user_file /etc/nginx/htpasswd.users;

    location / {
        proxy_pass http://localhost:5601;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \\\$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \\\$host;
        proxy_cache_bypass \\\$http_upgrade;
    }
}
EOT
exit
EOC
echo "admin:`openssl passwd -apr1 $kibanapassword`" | sudo tee -a /etc/nginx/htpasswd.users
sudo systemctl restart nginx

# Install & configure logstash
sudo apt-get install logstash -y
sudo mkdir -p /etc/pki/tls/certs
sudo mkdir /etc/pki/tls/private
cd /etc/pki/tls; sudo openssl req -subj '/CN='$elkip'/' -x509 -days 3650 -batch -nodes -newkey rsa:2048 -keyout private/logstash-forwarder.key -out certs/logstash-forwarder.crt
cat <<EOC | sudo su
cat <<EOT > /etc/logstash/conf.d/02-beats-input.conf
input {
  beats {
    port => 5044
    ssl => false
    #ssl_certificate => "/etc/pki/tls/certs/logstash-forwarder.crt"
    #ssl_key => "/etc/pki/tls/private/logstash-forwarder.key"
  }
}
EOT
exit
EOC
cat <<EOC | sudo su
cat <<EOT > /etc/logstash/conf.d/30-elasticsearch-output.conf
output {
  elasticsearch {
    hosts => "localhost:9200"
    sniffing => true
    manage_template => false
    index => "%{[@metadata][beat]}-%{+YYYY.MM.dd}"
    document_type => "%{[@metadata][type]}"
  }
}
EOT
exit
EOC
sudo systemctl daemon-reload
sudo /usr/share/logstash/bin/logstash-plugin install logstash-input-beats
sudo systemctl enable logstash.service
sudo systemctl restart logstash.service

# Install & configure filebeat
sudo apt-get install filebeat -y
sudo systemctl daemon-reload
sudo systemctl enable filebeat.service
sudo filebeat export template | sudo tee /etc/filebeat/filebeat.template.json
curl -H 'Content-Type: application/json' -XPUT 'http://localhost:9200/_template/filebeat' -d@/etc/filebeat/filebeat.template.json
sudo filebeat setup --dashboards
sudo filebeat modules enable nginx
sudo systemctl restart filebeat
