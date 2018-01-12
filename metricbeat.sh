# Install & configure metricbeat
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get update
sudo apt-get install metricbeat -y
sudo sed -i "s/reload.enabled: .*/reload.enabled: true/" /etc/metricbeat/metricbeat.yml
sudo systemctl daemon-reload
sudo systemctl enable metricbeat.service
sudo systemctl restart metricbeat
