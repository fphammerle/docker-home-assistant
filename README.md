https://www.home-assistant.io/docs/installation/docker/

https://github.com/home-assistant/home-assistant/blob/dev/virtualization/Docker/setup_docker_prereqs

https://github.com/home-assistant/home-assistant/blob/dev/requirements_all.txt

```sh
$ sudo docker build --tag=home-assistant .
$ sudo docker volume create home-assistant-config
$ cat /etc/udev/rules.d/zwave.rules
ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="zwave-dongle"
# check permissions of /dev/zwave-dongle
$ sudo docker run --rm --publish=8123:8123 \
    --mount "source=home-assistant-config,target=/config,rw" \
    --device /dev/zwave-dongle:/dev/zwave-dongle \
    --security-opt=no-new-privileges --cap-drop=all \
    home-assistant
```
