# Install & configure filebeat
sudo apt-get install filebeat -y
sudo sed -i "s/enabled: .*/enabled: true/" /etc/filebeat/filebeat.yml
sudo systemctl daemon-reload
sudo systemctl enable filebeat.service
sudo filebeat modules enable nginx
#sudo filebeat -v -modules=nginx -setup
sudo systemctl restart filebeat