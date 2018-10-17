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

COPY --chown=hass ./runtime-requirements.txt /tmp
RUN pip install --user --no-cache-dir --requirement /tmp/runtime-requirements.txt \
    && rm /tmp/runtime-requirements.txt

RUN pip install --user --no-cache-dir \
    homeassistant==0.80.2 \
    home-assistant-frontend==20181017.0

CMD ["python", "-m", "homeassistant", "--config", "/config"]
