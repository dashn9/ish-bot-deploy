#!/bin/bash

{
echo && echo "$0: " && echo

# Set the project name from the first argument
PROJ_NAME=$1
ETCD_NAME=$(hostname -s)
CLOUD_PROVIDER="gcp"
meta() {
    if [ "$CLOUD_PROVIDER" == "aws" ]; then
        curl -s "http://169.254.169.254/latest/meta-data/$1"
    elif [ "$CLOUD_PROVIDER" == "gcp" ]; then
        curl -s -H "Metadata-Flavor: Google" "http://169.254.169.254/computeMetadata/v1/$1"
    else
        echo "Unsupported cloud provider: $CLOUD_PROVIDER"
        exit 1
    fi
}

HOSTNAME=$(hostname -s)
if [ "$CLOUD_PROVIDER" == "aws" ]; then
    INTERNAL_IP=$(meta local-ipv4)
elif [ "$CLOUD_PROVIDER" == "gcp" ]; then
    INTERNAL_IP=$(meta instance/network-interfaces/0/ip)
fi

# Create necessary directories and copy certificates
sudo mkdir -p /etc/etcd /var/lib/etcd
sudo cp k8s-ca.crt etcd.crt etcd.key /etc/etcd/

# Create the systemd service file for etcd
cat <<EOF | sudo tee /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
ExecStart=/usr/local/bin/etcd \\
  --name ${ETCD_NAME} \\
  --cert-file=/etc/etcd/etcd.crt \\
  --key-file=/etc/etcd/etcd.key \\
  --peer-cert-file=/etc/etcd/etcd.crt \\
  --peer-key-file=/etc/etcd/etcd.key \\
  --trusted-ca-file=/etc/etcd/k8s-ca.crt \\
  --peer-trusted-ca-file=/etc/etcd/k8s-ca.crt \\
  --peer-client-cert-auth=true \\
  --client-cert-auth=true \\
  --initial-advertise-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-peer-urls https://${INTERNAL_IP}:2380 \\
  --listen-client-urls https://${INTERNAL_IP}:2379,https://127.0.0.1:2379 \\
  --advertise-client-urls https://${INTERNAL_IP}:2379 \\
  --initial-cluster-token etcd-cluster-0 \\
  --initial-cluster ${ETCD_NAME}=https://${INTERNAL_IP}:2380 \\
  --initial-cluster-state new \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable, and start etcd
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd

# Verify that everything is working
sudo ETCDCTL_API=3 etcdctl member list \
    --endpoints=https://127.0.0.1:2379 \
    --cacert=/etc/etcd/k8s-ca.crt \
    --cert=/etc/etcd/etcd.crt \
    --key=/etc/etcd/etcd.key

} >> start_etcd.log 2>&1
