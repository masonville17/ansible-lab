#!/bin/bash

# Hosts file content
echo "[servers]" > hosts
echo "master ansible_host=<master_node_ip>" >> hosts
echo "slave ansible_host=<slave_node_ip>" >> hosts

# Generate a new ED25519 key pair on the master, if it doesn't exist yet
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
fi

# Ansible playbook content
echo "---" > distribute_ssh_keys.yml
echo "- hosts: servers" >> distribute_ssh_keys.yml
echo "  gather_facts: no" >> distribute_ssh_keys.yml
echo "  tasks:" >> distribute_ssh_keys.yml
echo "    - name: install sshpass for key distribution" >> distribute_ssh_keys.yml
echo "      apt:" >> distribute_ssh_keys.yml
echo "        name: sshpass" >> distribute_ssh_keys.yml
echo "        state: present" >> distribute_ssh_keys.yml
echo "      become: yes" >> distribute_ssh_keys.yml
echo "    - name: distribute ssh key" >> distribute_ssh_keys.yml
echo "      authorized_key:" >> distribute_ssh_keys.yml
echo "        user: <slave_node_username>" >> distribute_ssh_keys.yml
echo "        state: present" >> distribute_ssh_keys.yml
echo "        key: \"{{ lookup('file', '/root/.ssh/id_ed25519.pub') }}\"" >> distribute_ssh_keys.yml

# Run Ansible playbook
ansible-playbook -i hosts -u <master_node_username> --ask-become-pass distribute_ssh_keys.yml

