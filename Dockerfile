ARG HOME_ASSISTANT_VERSION=0.104.3
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
RUN apk add --no-cache \
    gcc \
    musl-dev

# inherited:
# CMD ["python3", "-m", "homeassistant", "--config", "/config"]

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
