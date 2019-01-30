#!/bin/bash
#Install node exporter
wget https://github.com/prometheus/node_exporter/releases/download/v0.17.0-rc.0/node_exporter-0.17.0-rc.0.linux-amd64.tar.gz
tar -xzf node_exporter-*.linux-amd64.tar.gz
cd node_exporter-*.linux-amd64
sudo ./node_exporter  &

sudo wget https://github.com/prometheus/prometheus/releases/download/v2.7.0-rc.0/prometheus-2.7.0-rc.0.linux-amd64.tar.gz
sudo tar xvfz prometheus-*.tar.gz
cd prometheus-*
sudo chmod 777 prometheus.yml

sudo cat <<EOF >  ./prometheus.yml

# my global config
global:
  scrape_interval:     15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
  - static_configs:
    - targets:
      # - alertmanager:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
  # - "first_rules.yml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: 'prometheus'

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
    - targets: ['localhost:9090']

  - job_name: dummy
    consul_sd_configs:
      - server: 'localhost:8500'
    relabel_configs:
      - source_labels: [__meta_consul_tags]
        regex: .*,dummy,.*
        action: keep
      - source_labels: [__meta_consul_service]
        target_label: dummy

EOF

sudo ./prometheus --config.file=prometheus.yml &