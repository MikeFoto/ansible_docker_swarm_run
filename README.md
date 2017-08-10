# Docker services management

# base management to docker swarm cluster

* start services

* rm services

* volume creation

# Usage

Define the Configuration hash some place . Check Examples at defaults/main.yml.ex

## Configuration Capabilities

### Example 1
* Create 2 volumes
* Start 1 service
* remove one service

```yaml
swarm_run:                              # Generic example
  volumes:
    create:                              # volumes List to be created
      - name:     demo_volume_1          # volume name
        option:   "none"                 # Any option to volume creation can be specified here
      - name:     demo_volume_2
        option:   "none"
  services:
    start:                              # define services here
                                        # if the service is running will not
                                        #   change anything
      - name:     demo_service_1        # service name
        image:    alpine                # service image
        tag:      latest                # image tag
        command:  "ping docker.com"     # Command to run on the image
        options:                             # Any service option can go here
                                             # see examples bellow
          --mount type=volume,source=demo_volume_1,destination=/tmp
          --replicas 1
          --update-delay 10s
          --update-parallelism 3
    remove:                           # Define the servives to be removed
      - name:     demo_service_3

# Examples for service option
  # --replicas 1             Number or replicas in the swarm for the service
  # --mode global            service in each node of the cluster
  # --update-delay 10s       how often check for updates
  # --update-parallelism 3   How many concurrent updates
  # -- publish 8080:80       expose a port to ouside world and connect local port
  #                          optional protocol eg:/tcp
  #                          can be used several times
  # --env MYVAR=myvalue      set environment variable
  # --workdir /tmp           set working dir
  # --user my_user           set user
  # --mount
  #     type=volume,
  #     source=my-volume,
  #     destination=/path/in/container,
  #     volume-label="color=red",
  #     volume-label="shape=round" \

```


# Example 2
* Load balancing btw 2 nginx servers  testing if they are running
* demo the replicas options   and publishing public ports
```yaml
swarm_aux2:                              # aux values used in configuration
  exposed_ports:
    nginx1:         8080
    nginx2:         8081

swarm_run:
  test:                   # List of command to run after deploy the services.
                          #   Can be used for testing
    - name:    test1
      command: "curl --max-time 1 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.nginx1 }}"
    - name:    test2
      command: "curl --max-time 1 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.nginx2 }}"
  services:
    start:
      - name:     demo2_nginx_1
        image:    nginx
        tag:      latest
        options:
          --replicas 3
          --publish {{ swarm_aux.exposed_ports.nginx1 }}:80       # Access service on 8080 @ any swarm host
      - name:     demo2_nginx_2
        image:    nginx
        tag:      latest
        options:
          --replicas 3
          --publish {{ swarm_aux.exposed_ports.nginx2 }}:80       # Access service on 8081 @ any swarm host
```

# TODO


* check service status aflter creation or deletion

* update services

```bash
docker service update --image redis:3.0.7 redis redis
```

* tests

# License

MIT

# Author Information

Created by Miguel Rodrigues
