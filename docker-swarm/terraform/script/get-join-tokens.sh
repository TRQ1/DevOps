WORKER=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$HOST docker swarm join-token worker -q)
MANAGER=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@$HOST docker swarm join-token manager -q)
