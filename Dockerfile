FROM python:3.7

RUN find /usr/bin -type f -perm /u+s -exec echo chmod --changes u-s {} \;
RUN find /usr/bin -type f -perm /g+s -exec echo chmod --changes g-s {} \;

VOLUME /config

RUN useradd --create-home hass && chown hass ~hass
USER hass
ENV PATH "/home/hass/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir homeassistant

CMD ["python", "-m", "homeassistant", "--config", "/config"]
