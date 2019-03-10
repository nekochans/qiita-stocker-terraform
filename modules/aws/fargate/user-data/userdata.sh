#!/bin/bash

cat << EOT >> /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
EOT
