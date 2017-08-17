
# Notes

# Containers

# images

## Remove container
```bash
sudo docker rm <ID>
```

# Images

## Find all tags for one image

```bash
export REGISTRY=https://registry.hub.docker.com/v1/repositories
export IMAGE_NAME=alpine
wget -q $REGISTRY/$IMAGE_NAME/tags -O -  | \
  sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | \
  tr '}' '\n'  | \
  awk -F: '{print $3}'
#wget -q https://registry.hub.docker.com/v1/repositories/alpine/tags -O -  | sed -e 's/[][]//g' -e 's/"//g' -e 's/ //g' | tr '}' '\n'  | awk -F: '{print $3}'
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
