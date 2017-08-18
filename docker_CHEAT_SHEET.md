
# Notes

Previsous to run any example set if sudo if necessary
```bash
export SUDO="sudo" # revert order if sudo necessary
export SUDO=""
```

## Containers

### Remove container
```bash
$SUDO docker rm <ID>
```

### Run one container
```bash
$SUDO docker rm <ID>
```

## Images

### Find all tags for one image
```bash
export REGISTRY=https://registry.hub.docker.com/v1/repositories
export IMAGE_NAME=alpine
wget -q $REGISTRY/$IMAGE_NAME/tags -O -  | \
  sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | \
  tr '}' '\n'  | \
  awk -F: '{print $3}'
```

### List all images
```bash
$SUDO docker image list
```

### Find images dependent from base image
```bash
export IMG=`$SUDO docker image list  | sed -e "s/ \+/ /g" | cut -f 3 -d " "`
for i in $IMG
do
  $SUDO docker inspect --format='{{.Id}} + {{.Parent}}'  $i
done
```

### Remove one image
```bash
$SUDO docker rmi <image id >
```

### Run one image with bash ( or any command )
```bash
export IMAGE=python
export COMMAND=/bin/bash
$SUDO docker run -it python $COMMAND
```
