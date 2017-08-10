
# Notes

# Containers

## Remove container
```bash
sudo docker rm <ID>
```

# Images

## Find all tags for one image

```bash
wget -q https://registry.hub.docker.com/v1/repositories/alpine/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}'
```

## list all images
```bash
sudo docker image list
```

## Find images dependent from base image
```bash
export IMG=`sudo docker image list  | sed -e "s/ \+/ /g" | cut -f 3 -d " "`
for i in $IMG; do sudo docker inspect --format='{{.Id}} + {{.Parent}}'  $i; done

```

# Remove one image
```bash
sudo docker rmi <image id >
```

# Notes on swarn

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
