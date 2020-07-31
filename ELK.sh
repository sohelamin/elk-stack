#/bin/bash
echo -n "Enter ELK Server's Domain/IP: "
read elkip
echo -n "Enter Kibana Admin Web Password: "
read kibanapassword

# Update the system
sudo apt-get update

# Install java
sudo apt-get update
sudo apt-get install default-jdk -y

# Add elasticsearch package source
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo apt-get install apt-transport-https -y
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update

# Install elasticsearch
sudo apt-get install elasticsearch -y
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl restart elasticsearch.service

# Install kibana
sudo apt-get install kibana -y
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

cat <<EOC | sudo su
cat <<EOT > /etc/logstash/conf.d/02-beats-input.conf
input {
  beats {
    port => 5044
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
  # if "shouldalert" in [tags] {
  #   slack {
  #       url => <YOUR SLACK WEBHOOK URL HERE>
  #   }
  # }
}
EOT
exit
EOC
sudo systemctl daemon-reload
sudo /usr/share/logstash/bin/logstash-plugin install logstash-input-beats
#sudo /usr/share/logstash/bin/logstash-plugin install logstash-output-slack
sudo systemctl enable logstash.service
sudo systemctl restart logstash.service
