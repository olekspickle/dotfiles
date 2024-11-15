#!/bin/bash

# SSH into docket container
docker exec -it <container-name-or-id> bash

# investigate all resources size
docker system df -v

# Get the total size of all docker images on a machine
docker images --format "{{.Size}}" | awk '{s+=$1/1024} END {print "Total size: " s " Gb"}'

# To analyze the differences between two Docker images using a Bash one-liner,
# utilize the docker history command and compare the image layers. 
docker history --no-trunc <IMAGE_ID> | awk '{print $1}' | tail -n +2 | xargs -I {} sh -c "echo {}; docker inspect --format='{{range .RootFS.Layers}}{{println .}}{{end}}' {}" | sort | uniq -c

# execute stuff for all running containers
docker container ls --format "{{.ID}}" | xargs -I {} docker exec {} "docker inspect {} -f '{{ .GraphDriver.Name }}'"

# gives you only ids
docker ps -q
