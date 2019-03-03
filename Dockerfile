FROM python:3.7

RUN find /usr/bin -type f -perm /u+s -exec echo chmod --changes u-s {} \;
RUN find /usr/bin -type f -perm /g+s -exec echo chmod --changes g-s {} \;

# required to build python_openzwave
# https://github.com/OpenZWave/python-openzwave
RUN apt-get update && apt-get install --yes make g++ libudev-dev libyaml-dev

RUN useradd --create-home hass && chown hass ~hass

RUN mkdir /config && chown hass /config
VOLUME /config

USER hass
ENV PATH "/home/hass/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir python_openzwave==0.4.9
COPY --chown=hass ./runtime-requirements.txt /tmp
RUN pip install --user --no-cache-dir --requirement /tmp/runtime-requirements.txt \
    && rm /tmp/runtime-requirements.txt

RUN pip install --user --no-cache-dir \
    homeassistant==0.80.3 \
    home-assistant-frontend==20181018.0

CMD ["python", "-m", "homeassistant", "--config", "/config"]
