#!/usr/bin/env bash
IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
NODENAME="$(curl http://169.254.169.254/latest/meta-data/hostname)"

#Install java
sudo apt-get update
sudo apt-get install -y unzip
sudo apt-get install -y openjdk-8-jre-headless
sudo apt-get install -y openjdk-8-jdk-headless
#install elasstic
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.deb
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.5.4.deb.sha512
shasum -a 512 -c elasticsearch-6.5.4.deb.sha512
sudo dpkg -i elasticsearch-6.5.4.deb

sudo /bin/systemctl daemon-reload

sudo /bin/systemctl enable elasticsearch.service

sudo systemctl start elasticsearch.service
 
#Install kibana
sudo wget https://artifacts.elastic.co/downloads/kibana/kibana-6.5.4-amd64.deb
sudo shasum -a 512 kibana-6.5.4-amd64.deb
sudo dpkg -i kibana-6.5.4-amd64.deb
chmod +w /etc/kibana/kibana.yml
cat << EOF >/etc/kibana/kibana.yml
server.name: kibana
server.host: "0.0.0.0"
EOF
sudo systemctl stop kibana.service
sudo systemctl start kibana.service

#install logstash
sudo wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list
sudo apt-get install apt-transport-https -y
sudo apt-get update && sudo apt-get install logstash -y

sudo systemctl start logstash.service

#install consul
echo "Download & unzip Consul..."

sudo wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
sudo unzip consul_1.4.0_linux_amd64.zip
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul

# Setup Consul
sudo mkdir -p /opt/consul
sudo mkdir -p /etc/consul.d
sudo mkdir -p /run/consul


sudo cat <<EOF >  /etc/consul.d/config.json
{
  "advertise_addr": "$IP",
  "data_dir": "/opt/consul",
  "datacenter": "midproj",
  "disable_remote_exec": true,
  "disable_update_check": true,
  "leave_on_terminate": true,
  "retry_join": ["provider=aws tag_key=consul_server tag_value=true"],
  "node_name": "$NODENAME",
  ${config}
}
EOF

# Create user & grant ownership of folders
sudo useradd consul
sudo chown -R consul:consul /opt/consul /etc/consul.d /run/consul


# Configure consul service
sudo cat <<EOF > /etc/systemd/system/consul.service 
[Unit]
Description=Consul service discovery agent
Requires=network-online.target
After=network-online.target
[Service]
User=consul
Group=consul
#PIDFile=/run/consul/consul.pid
Restart=on-failure
Environment=GOMAXPROCS=2
ExecStartPre=[ -f "/run/consul/consul.pid" ] && /usr/bin/rm -f /run/consul/consul.pid
ExecStart=/usr/local/bin/consul agent -pid-file=/run/consul/consul.pid -config-dir=/etc/consul.d
ExecReload=/bin/kill -s HUP $MAINPID
KillSignal=SIGINT
TimeoutStopSec=5
[Install]
WantedBy=multi-user.target
EOF
#register elasstic service to consul
sudo cat <<EOF > /etc/consul.d/elasstic.json
{"service": {
    "name": "elasstic",
    "tags": ["elasstic"],
    "port": 9200,
    "check": {
        "http": "http://localhost:9200",
        "interval": "10s"
        }
    }
}
EOF
#register kibana service to consul
sudo cat <<EOF > /etc/consul.d/kibana.json
{"service": {
    "name": "kibana",
    "tags": ["kibana"],
    "port": 5601,
    "check": {
        "http": "http://localhost:5601",
        "interval": "10s"
        }
    }
}
EOF

sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service