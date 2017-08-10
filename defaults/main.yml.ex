################################################################################
#  swarm_run Role

swarm_aux2:                              # aux values used in configuration
  exposed_ports:
    nginx1:         8080
    nginx2:         8081

swarm_aux3:                              # aux values used in configuration
  exposed_ports:
    microservice1:   9080
    microservice2:   9081
    microservice3:   9082
    microservice4:   9083
  internal_ports:
    microservice1:   2000
    microservice2:   2010
    microservice3:   2020
    microservice4:   2030

swarm_aux4:                              # aux values used in configuration
  exposed_ports:
    nginx1:         8080
    nginx2:         8081

swarm_aux: "{{ swarm_aux4 }}"

swarm_run1:                              # Generic example
  documentation: |
    * we can define any number of volumes and any option for each volume on *swarm_run.volumes.create*
    * we can defined any number of services
    ** with associated images
    ** commands to run
    ** service options
  volumes:
    create:                              # define volumes here
      - name:     demo_volume_1
        option:   "none"
      - name:     demo_volume_2
        option:   "none"
  services:
    start:                              # define services here
                                        # if the service is running will not
                                        #   change anything
      - name:     demo_service_1
        image:    alpine
        tag:      latest
        command:  "ping docker.com"
        options:                             # Any service option can go here
                                             # see examples bellow
          --mount type=volume,source=demo_volume_1,destination=/tmp
          --replicas 1
          --update-delay 10s
          --update-parallelism 3
      - name:     demo_service_2
        image:    alpine
        tag:      latest
        command:  "ping docker.com"
        options:                             # Any service option can go here
          --replicas 3
      - name:     demo_service_3
        image:    alpine
        tag:      latest
        options:                             # Any service option can go here
          --replicas 1
        command:  "ping docker.com"
    # remove:                           # Define the servives to be removed
      # - name:     demo_service_3

swarm_run2:                              # nginx example
  documentation: |
    on top of example1 we can add tests that will run after all the services where deployed
  test:
    - name:    test1
      command: "curl --max-time 1 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.nginx1 }}"
    - name:    test2
      command: "curl --max-time 1 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.nginx2 }}"
  volumes:
    create:                              # define volumes here
      - name:     demo2_volume_1
        option:   "none"
  services:                               # single service at 8080
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

swarm_run3:                              # microservice  example
  documentation: |
    pratical example of an microservice architecture with 4 service , 3 replicas for each
  test:
    - name:    test1      # basic testing to each service
      command: |
        curl --max-time 20 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.microservice1 | default(2000) }}
    - name:    test2
      command: |
        curl --max-time 20 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.microservice2 | default(2001) }}
    - name:    test3
      command: |
        curl --max-time 20 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.microservice3 | default(2002) }}
    - name:    test4
      command: |
        curl --max-time 20 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.microservice4 | default(2003) }}
    - name:    test5     # sequential test in same service
      command: |
        NUMTEST=10000
        TIMEOUT=0.1
        for i in {1..$NUMTEST}
        do
          curl --max-time $TIMEOUT {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.microservice4 | default(2003) }}
        done
  services:
    start:
      - name:     demo3_microservice_1
        image:    python
        tag:      latest
        command: |
          python -m http.server {{ swarm_aux.internal_ports.microservice1 | default("8080")}}
        options:
          --replicas 3
          --publish {{ swarm_aux.exposed_ports.microservice1 | default("2000")}}:{{ swarm_aux.internal_ports.microservice1 | default("8080")}}
      - name:     demo3_microservice_2
        image:    python
        tag:      latest
        command: |
          python -m http.server {{ swarm_aux.internal_ports.microservice2 | default("8081")}}
        options:
          --replicas 3
          --publish {{ swarm_aux.exposed_ports.microservice2 | default("2001")}}:{{ swarm_aux.internal_ports.microservice2 | default("8081")}}
      - name:     demo3_microservice_3
        image:    python
        tag:      latest
        command: |
          python -m http.server {{ swarm_aux.internal_ports.microservice3 | default("8082")}}
        options:
          --replicas 3
          --publish {{ swarm_aux.exposed_ports.microservice3 | default("2002")}}:{{ swarm_aux.internal_ports.microservice3 | default("8082")}}
      - name:     demo3_microservice_4
        image:    python
        tag:      latest
        command: |
          python -m http.server {{ swarm_aux.internal_ports.microservice4 | default("8083")}}
        options:
          --replicas 3
          --publish {{ swarm_aux.exposed_ports.microservice4 | default("2003")}}:{{ swarm_aux.internal_ports.microservice4 | default("8083")}}

swarm_run4:                              # shared volume  example
  preconditions:
    directories:
      - "/tmp/lixo"
  test:
    - name:    test1
      command: "curl --max-time 1 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.nginx1 }}"
    - name:    test2
      command: "curl --max-time 1 {{ swarm_manager_ip }}:{{ swarm_aux.exposed_ports.nginx2 }}"
  volumes:
    create:                              # define volumes here
      - name:     demo4_volume_1
        option:   "none"
  services:                               # single service at 8080
    start:
      - name:     demo4_nginx_1
        image:    nginx
        tag:      latest
        options:
          --replicas 2
          --publish {{ swarm_aux.exposed_ports.nginx1 }}:80
          --mount type=volume,source=demo_volume_1,destination=/tmp
      - name:     demo4_nginx_2
        image:    nginx
        tag:      latest
        options:
          --replicas 2
          --publish {{ swarm_aux.exposed_ports.nginx2 }}:80


swarm_run: "{{ swarm_run4 }}"

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

swarm_run_readme: |
  # Setup a Docker Swarm cluster with 3 nodes

  * Provisioned by ansible

  * Using public ansible roles

  # Notes
  Current Vagrant file use virtualbox provisioner for demo purposes .
  Change to any other provisioner by changing configuration file

  # Setup

  * change ansible.cfg to match your local setup

  * ansible_galaxy_roles - external dependencies from other contributors
  * * hostnames Role created by Antti J. Salminen in 2014 (TODO: include URL).

  * ansible_roles_public - roles created by myself , available at https://Foto@bitbucket.org/MikeFoto/ansible_roles_public.git


  # Usage

  * Create the cluster
  ```bash
  vagrant up
  ```

  * Update the cluster
  to add nodes just edit the file *hosts.yaml*

  * Launch defined services
  ```bash
  ansible-playbook  \
    -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
    --extra-vars='swarm_manager_ip=192.168.33.20' \
     ansible/playbooks/swarm_run.yml

  ```

  # Examples included

  ## Example1
  {{ swarm_run1.documentation | default ("no documentation for example1 ")}}
  ## Example2
  {{ swarm_run2.documentation | default ("no documentation for example2 ")}}
  ## Example3
  {{ swarm_run3.documentation | default ("no documentation for example3 ")}}

# END swarm_run  Role
################################################################################
