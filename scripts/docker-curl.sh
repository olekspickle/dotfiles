#! /bin/bash

if [ -z "$SOME_PROVIDER_SOCKET" ]
then
    DOCKER_SOCKET=/var/run/docker.sock
else
    DOCKER_SOCKET=$PROVIDERS_SOCKET
fi

API_VERSION=$(curl -s --unix-socket $DOCKER_SOCKET http://v/version | jq '.Components[0].Version' | sed 's/\"//g')

container_id=$(
    curl --unix-socket $DOCKER_SOCKET -s http://$API_VERSION/containers/json \
    | jq -r '.[] | select(.Image | contains("some_name") or contains("other_name")) | .Id'
)

# Create a new container with the volume mount and command
create_response=$(curl -s --unix-socket $DOCKER_SOCKET -X POST -H "Content-Type: application/json" -d '{
  "Image": "'$container_id'",
  "Cmd": ["bash", "-c", "sleep infinity"],
  "HostConfig": {
    "Binds": ["/var/run/test/:/var/run/test/"]
  }
}' http://$API_VERSION/containers/create)


# Extract the new container ID
new_container_id=$(echo $create_response | jq -r '.Id')

# Start the new container
curl -s --unix-socket $DOCKER_SOCKET -X POST http://$API_VERSION/containers/$new_container_id/start

# Wait for the container to finish
curl -s --unix-socket $DOCKER_SOCKET -X POST http://$API_VERSION/containers/$new_container_id/wait

# Remove the container
curl -s --unix-socket $DOCKER_SOCKET -X DELETE http://$API_VERSION/containers/$new_container_id
