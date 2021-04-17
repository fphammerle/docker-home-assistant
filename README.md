# docker: home assistant 🏡🐳

simple wrapper for
[home-assistant](https://github.com/home-assistant/home-assistant)'s
[official docker image](https://hub.docker.com/r/homeassistant/home-assistant).

changes:
* dropped `setuid` and `setgid` permission bits from all files
* run home assistant as an unprivileged user (instead of `root`)

guide: https://www.home-assistant.io/docs/installation/docker/

dockerfile: https://git.hammerle.me/fphammerle/docker-home-assistant/src/master/Dockerfile

signed docker image hashes: https://github.com/fphammerle/docker-home-assistant/tags

```sh
$ sudo docker run --name home_assistant \
    -v home_assistant_config:/config:rw \
    -p 8123:8123 \
    --read-only --tmpfs /home/hass/.config/async_dns:mode=1777,size=4k
    --security-opt=no-new-privileges --cap-drop=all \
    --restart unless-stopped \
    fphammerle/home-assistant
```

## mount zwave dongle

```
$ cat /etc/udev/rules.d/zwave.rules
ACTION=="add", SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", SYMLINK+="zwave-dongle"
# check permissions of /dev/zwave-dongle
$ sudo docker run --device /dev/zwave-dongle:/dev/zwave-dongle …
```

## mount `/proc/device-tree`

Required by `Adafruit-DHT`:
https://github.com/adafruit/Adafruit_Python_DHT/blob/a609d7dcfb2b8208b88498c54a5c099e55159636/source/Raspberry_Pi_2/pi_2_mmio.c#L43

`/proc/device-tree` is a symlink to `/sys/firmware/devicetree/base`.

However, `docker run -v /sys/firmware/devicetree/base:/sys/firmware/devicetree/base:ro …` is ineffective.

Docker masks `/sys/firmware`:
https://github.com/moby/moby/pull/26618
https://github.com/docker/docker-ce/blob/v19.03.5/components/engine/oci/defaults.go#L127

Evil workaround:
```sh
# start container without explicitly mounting devicetree
$ sudo docker run --name home_assistant …
# umount shadowing tmpfs
$ sudo nsenter --target $(sudo docker inspect --format={{.State.Pid}} home_assistant) --mount umount /sys/firmware
```
