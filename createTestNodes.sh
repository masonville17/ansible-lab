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

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y openssh-server

RUN mkdir /var/run/sshd
RUN echo 'root:$password' | chpasswd
#RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# Create a non-root user: $username
#RUN useradd -m $username && echo "$username:$username" | chpasswd && adduser $username sudo


RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

# Switch to the new user in the Docker image
#USER $username

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
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

# Deploying on Kubernetes
kubectl apply -f deployment.yaml

