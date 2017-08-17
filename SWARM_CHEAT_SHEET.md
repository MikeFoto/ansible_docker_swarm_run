# Notes on swarm

## Start service

```bash
export IMAGE=apline
export TAG=latest
export TAG=2.6
docker service create --replicas 1 --name helloworld alpine ping docker.com
```

## Check services running

```bash
docker service ls
```


## Inspect  service
```bash
docker service inspect --pretty helloworld
# or
docker service inspect helloworld
```

## Check where service is running   service
```bash
docker service ps helloworld
```

## scale service
```bash
docker service scale helloworld=6
```

## remove  service
```bash
docker service rm helloworld
```
