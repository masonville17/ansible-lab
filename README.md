## **Ansible-Lab**
This is a simple quickstart I've created that includes automation for master node initialization, subservient node initialization, and ED25519 SSH Key Exchange.


![image](https://github.com/masonville17/ansible-lab/assets/90802741/6c17065d-5da8-45f5-b9f7-1e4ce19032db)


`bash addnode.sh` can be used to initialize a master node. If no ED25519 key is present in the user's `~/.ssh/id_ed25519(.pub)` file, one will be generated for exchange with subservient nodes.
