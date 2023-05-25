#!/bin/bash
source ./helpers/validate
# Prompt for username
read -p "Enter your username: " username

# Validate username input
if [[ -z "$username" ]]; then
  echo "Username is required."
  exit 1
fi

# Prompt for password (without echoing the input)
read -s -p "Enter your password: " password
echo

# Validate password input
if [[ -z "$password" ]]; then
  echo "Password is required."
  exit 1
fi
# Prompt for Replica Count
while true; do
	read -p "Enter # of Replicas (1-100): " replicaCount
  if validate_input "$replicaCount"; then
    break
  fi
done
# Dockerfile content
cat <<EOF > Dockerfile
FROM ubuntu:22.04
LABEL maintainer="Original Ansible Test Docker Image from Jeff Geerling"
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
       openssh-server \
       apt-utils \
       build-essential \
       locales \
       libffi-dev \
       libssl-dev \
       libyaml-dev \
       python3-dev \
       python3-setuptools \
       python3-pip \
       python3-yaml \
       software-properties-common \
       rsyslog systemd systemd-cron sudo iproute2 \
    && apt-get clean \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# Fix potential UTF-8 errors with ansible-test.
RUN locale-gen en_US.UTF-8

# Install Ansible via Pip.
RUN pip3 install $pip_packages

COPY initctl_faker .
RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Install Ansible inventory file.
RUN mkdir -p /etc/ansible
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Remove unnecessary getty and udev targets that result in high CPU usage when using
# multiple containers with Molecule (https://github.com/ansible/molecule/issues/1104)
RUN rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

VOLUME ["/sys/fs/cgroup", "/tmp", "/run"]
CMD ["/lib/systemd/systemd"]
EOF

# Building Docker Image
docker build -t testingnode .

# Kubernetes deployment YAML content
cat <<EOF > deployment.yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ubuntu-set
spec:
  replicas: $replicaCount
  selector:
    matchLabels:
      app: ubuntu
  template:
    metadata:
      labels:
        app: ubuntu
    spec:
      containers:
      - name: ubuntu
        image: testingnode
        ports:
        - containerPort: 22
EOF

# Deploying local

