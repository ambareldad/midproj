#!/bin/bash
#Install docker on ec2 machine
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates curl software-properties-commo
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

#pull dummy exporter image
sudo docker pull eldada/eldadmidproj:dummyexporter

#run container with dummy exporter app
sudo docker run -p 65433:65433 -v /tmp:/tmp eldada/eldadmidproj:dummyexporter &

echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y unzip
NODENAME="$(curl http://169.254.169.254/latest/meta-data/hostname)"
echo "Download & unzip Consul..."
#cd /tmp
sudo wget https://releases.hashicorp.com/consul/1.4.0/consul_1.4.0_linux_amd64.zip
sudo unzip consul_1.4.0_linux_amd64.zip
sudo rm consul_1.4.0_linux_amd64.zip
sudo chmod +x consul
sudo mv consul /usr/local/bin/consul

# Setup Consul
sudo mkdir -p /opt/consul
sudo mkdir -p /etc/consul.d
sudo mkdir -p /run/consul

sudo cat <<EOF >  /etc/consul.d/config.json
{
  "advertise_addr": "$(ifconfig eth0| head -2| tail -1| cut -d ":" -f2 | awk '{print $1}')",
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

# Register dummyexporter app to consul
sudo cat <<EOF > /etc/consul.d/dummyexporterapp.json
{"service": {
    "name": "dummyexporter",
    "tags": ["dummyexporter"],
    "port": 65433,
    "check": {
        "http": "http://localhost:65433",
        "interval": "10s"
        }
    }
}
EOF

sudo systemctl daemon-reload
sudo systemctl enable consul.service
sudo systemctl start consul.service