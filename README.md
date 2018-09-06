https://www.home-assistant.io/docs/installation/docker/

https://github.com/home-assistant/home-assistant/blob/dev/virtualization/Docker/setup_docker_prereqs

https://github.com/home-assistant/home-assistant/blob/dev/requirements_all.txt

```sh
sudo docker build --tag=home-assistant .
sudo docker volume create home-assistant-config
sudo docker run --rm --publish=8123:8123 \
    --mount "source=home-assistant-config,target=/config" \
    --security-opt=no-new-privileges --cap-drop=all \
    home-assistant
```
