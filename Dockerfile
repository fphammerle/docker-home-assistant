# https://hub.docker.com/r/homeassistant/home-assistant/tags
# https://github.com/home-assistant/core/blob/0.109.3/azure-pipelines-release.yml#L76
ARG HOME_ASSISTANT_VERSION=2021.2.3
FROM homeassistant/home-assistant:$HOME_ASSISTANT_VERSION

# Adafruit-DHT: no wheel available
# https://pypi.org/project/Adafruit-DHT/1.4.0/#files
# https://wheels.home-assistant.io/alpine-3.10/armv7/
#> $ sudo docker run --rm homeassistant/home-assistant:0.104.3 pip freeze | grep -i adafruit
#> starting version 3.2.8
#> Adafruit-Blinka==1.2.1
#> adafruit-circuitpython-busdevice==4.1.1
#> adafruit-circuitpython-mcp230xx==1.1.2
#> Adafruit-GPIO==1.0.3
#> Adafruit-PCA9685==1.0.1
#> Adafruit-PlatformDetect==1.4.5
#> Adafruit-PureIO==1.0.4
#> Adafruit-SHT31==1.0.2
# but no 'Adafruit-DHT'
# hadolint ignore=DL3018
RUN apk add --no-cache \
    gcc \
    musl-dev \
    tini

# not inherited:
EXPOSE 8123/tcp

# why do the home assistant maintainers run their containers as root?!
RUN python3 -c 'import os; assert os.geteuid() == 0, "finally..."' \
    && find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \; \
    && adduser -D hass \
    && chown hass /config \
    && mkdir -p ~hass/.config/pip \
    && echo -e '[install]\nuser = yes' > ~hass/.config/pip/pip.conf
VOLUME /config
USER hass

# > $ docker inspect --format '{{json .Config.Entrypoint}}' homeassistant/home-assistant:0.106.6
# > ["/bin/entry.sh"]
# > $ dockerinspect --format '{{json .Config.Cmd}}' homeassistant/home-assistant:0.106.6
# > ["python3","-m","homeassistant","--config","/config"]
# > $ dockerinspect --format '{{json .Config.Entrypoint}}' homeassistant/home-assistant:0.107.0
# > ["/init"]
# > $ dockerinspect --format '{{json .Config.Cmd}}' homeassistant/home-assistant:0.107.0
# > null
# see https://github.com/home-assistant/docker-base/pull/62
# > For now, `s6-overlay` doesn't support running it with a user different than `root`, so consequently Dockerfile `USER` directive is not supported (except `USER root` of course ;P).
# src: https://github.com/just-containers/s6-overlay/blame/v1.22.1.0/README.md#L420
# workaround: disable useless (but annoying) s6-overlay
ENTRYPOINT ["tini", "--"]
# default in home-assistant<0.107.0
CMD ["python3", "-m", "homeassistant", "--config", "/config"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION=
LABEL org.opencontainers.image.title="homeassistant/home-assistant:$HOME_ASSISTANT_VERSION running as unprivileged user" \
    org.opencontainers.image.source="https://github.com/fphammerle/docker-home-assistant" \
    org.opencontainers.image.revision="$REVISION"
