https://www.home-assistant.io/docs/installation/docker/

https://github.com/home-assistant/home-assistant/blob/dev/virtualization/Docker/setup_docker_prereqs

```sh
sudo docker build --tag=home-assistant .
sudo docker run --rm --publish=8123:8123 \
    --security-opt=no-new-privileges --cap-drop=all \
    home-assistant
```
