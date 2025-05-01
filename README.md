# Ish Bot Deployment

This repository contains infrastructure and deployment configurations for the Ish Bot application, which is deployed on Kubernetes clusters across AWS and GCP.

## Overview

The Ish Bot is a web-based bot application that runs in a containerized environment. It is deployed using Kubernetes manifests and managed via Terraform infrastructure code. The project supports deployment on both AWS and GCP cloud providers.

## Repository Structure

- **terraform/**: Contains Terraform configurations for provisioning infrastructure on AWS and GCP.
  - **AWS/**: AWS-specific Terraform modules for networking, compute, storage, and other resources.
  - **GCP/**: GCP-specific Terraform modules for networking, compute, storage, and other resources.
- **k8s/**: Kubernetes manifests for deploying the Ish Bot application.
  - **config.yml**: Configuration map for the Ish Bot.
  - **deployment.yml**: Deployment manifest for the Ish Bot.
  - **service.yml**: Service definition exposing the Ish Bot via NodePort.
- **scripts/**: Helper scripts for setting up and managing the Kubernetes cluster.
  - **k8s/**: Scripts for installing and configuring Kubernetes components.
    - **start_worker.sh**: Script to start and configure a Kubernetes worker node.
    - **start_control_plane.sh**: Script to start and configure the Kubernetes control plane.
    - **start_etcd.sh**: Script to start and configure etcd for the Kubernetes cluster.
    - **install_control_plane.sh**: Script to install Kubernetes control plane components.
    - **install_worker.sh**: Script to install Kubernetes worker components.
    - **generate_kubelet_config.sh**: Script to generate kubelet configuration.
    - **generate_admin_config.sh**: Script to generate admin kubeconfig.
- **others/**: Additional Kubernetes manifests and configurations.
  - **storageclass.yml**: Storage class definitions for persistent storage.
  - **gcp_storageclass.yml**: GCP-specific storage class definition.
  - **pod-definition.yml**: Pod definition for the Ish Bot.
  - **pvc.yml**: Persistent volume claim for the Ish Bot.
  - **replicaset-definition.yml**: ReplicaSet definition for the Ish Bot.

## Setup Instructions

### Prerequisites

- Terraform installed
- kubectl installed
- AWS or GCP account credentials configured

### Infrastructure Setup

1. Navigate to the `terraform` directory and choose your cloud provider (AWS or GCP).
2. Initialize Terraform:
   ```bash
   terraform init
   ```
3. Apply the Terraform configuration:
   ```bash
   terraform apply
   ```

### Kubernetes Cluster Setup

1. Use the scripts in the `scripts/k8s` directory to set up the Kubernetes cluster:
   - Run `install_control_plane.sh` on the control plane node.
   - Run `install_worker.sh` on each worker node.
   - Run `start_etcd.sh` on the etcd node.
   - Run `start_control_plane.sh` on the control plane node.
   - Run `start_worker.sh` on each worker node.

2. Generate the necessary kubeconfig files:
   - Run `generate_admin_config.sh` to generate the admin kubeconfig.
   - Run `generate_kubelet_config.sh` on each worker node.

### Deploying the Ish Bot

1. Apply the Kubernetes manifests in the `k8s` directory:
   ```bash
   kubectl apply -f k8s/config.yml
   kubectl apply -f k8s/deployment.yml
   kubectl apply -f k8s/service.yml
   ```

2. Apply the storage configurations:
   ```bash
   kubectl apply -f others/storageclass.yml
   kubectl apply -f others/gcp_storageclass.yml
   kubectl apply -f others/pvc.yml
   ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details. 