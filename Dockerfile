FROM python:3.7

RUN find /usr/bin -type f -perm /u+s -exec echo chmod --changes u-s {} \;
RUN find /usr/bin -type f -perm /g+s -exec echo chmod --changes g-s {} \;

VOLUME /config

# required to build python_openzwave
# https://github.com/OpenZWave/python-openzwave
RUN apt-get update && apt-get install --yes make g++ libudev-dev libyaml-dev

RUN useradd --create-home hass && chown hass ~hass
USER hass
ENV PATH "/home/hass/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir homeassistant

CMD ["python", "-m", "homeassistant", "--config", "/config"]
