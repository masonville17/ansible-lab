# ansible-lab
This is a simple quickstart I've created that includes automation for master node initialization, subservient node initialization, and ED25519 SSH Key Exchange.

Mostly Just for fun and re-education purposes, but I plan to make this an automated Ansible testing tool for any of the more common ecosystems/methodologies. eventually, I'll have it so one can spin up any number of nodes in any selected mix of ecosystems and, between them, test Ansible against them.

also be wary, need to not cat out generated Dockerfile, but rather set to variable, use/build image, set var to null. this will be changed soon.

here's what id eventually like to do:
1. Select Debian/Ubuntu based image from local or repo or build image from generated Dockerfile 
2. select ecosystems/methodologies to test against
3. for each selected ecosystem, prompt for number of nodes to spin up
4. prompt for log level, log as csv, notating ecosystem
5. spin up all, exchange keys
6. test
7. when finished, use xdg-open intent to open csv with default editor 

Also included, is an automated test node cluster creation script. Generates a Dockerfile, builds to an image, which is then deployed to a local cluster for testing.

1-Testing Kubernetes Modules: Ansible has specific modules for interacting with Kubernetes, such as k8s, k8s_info, etc. If your playbooks use these modules, having a Kubernetes cluster would be beneficial for testing.

2-Testing Ansible in a Distributed System: Kubernetes allows you to easily spin up multiple pods (which can be considered as separate hosts). If you want to test your Ansible playbooks in a distributed system, a Kubernetes cluster might be a good way to simulate that.

3-Integration Testing: If your Ansible playbooks are meant to configure a Kubernetes cluster or deploy resources to a cluster, it would make sense to have a test Kubernetes cluster.


`./addnode.sh` can be used to initialize a master node. If no ED25519 key is present in the user's `~/.ssh/id_ed25519.pub` file, one will be generated for exchange with subservient nodes.

`./createTestNodes.sh` can be used to create a Kubernetes cluster with a user-defined replica count, username, and password. (todo: use and echo back randomized hostnames into a generated inventory file for testing Ansible automations and tools )

*in production, we will not want to generate ssh keys in our cluster, the goal of ./createTestNodes.sh is to test ansible tools and utilities 

(todo: use of registry secret so kubectl can actually pull our built image)


![image](https://github.com/masonville17/ansible-lab/assets/90802741/6c17065d-5da8-45f5-b9f7-1e4ce19032db)
