# ansible-lab
This is a simple quickstart I've created that includes automation for master node initialization, subservient node initialization, and ED25519 SSH Key Exchange.

Also included, is an automated test node cluster creation script. Generates a Dockerfile, builds to an image, which is then deployed to a local cluster for testing. (in-progress)

`./addnode.sh` can be used to initialize a master node. If no ED25519 key is present in the user's `~/.ssh/id_ed25519.pub` file, one will be generated for exchange with subservient nodes.

`./createTestNodes.sh` can be used to create a Kubernetes cluster with a user-defined replica count, username, and password. (todo: use and echo back randomized hostnames into a generated inventory file for testing Ansible automations and tools )

*in production, we will not want to generate ssh keys in our cluster, the goal of ./createTestNodes.sh is to test ansible tools and utilities 

![image](https://github.com/masonville17/ansible-lab/assets/90802741/6c17065d-5da8-45f5-b9f7-1e4ce19032db)
