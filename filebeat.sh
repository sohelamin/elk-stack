# Install & configure filebeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt-get install filebeat -y
sudo sed -i "s/enabled: .*/enabled: true/" /etc/filebeat/filebeat.yml
sudo systemctl daemon-reload
sudo systemctl enable filebeat.service
sudo filebeat modules enable nginx
sudo systemctl restart filebeat
