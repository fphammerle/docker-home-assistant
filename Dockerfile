FROM python:3.7-alpine3.9

RUN apk add --no-cache \
    eudev-dev `#python_openzwave` \
    g++ \
    gcc \
    libffi-dev `#pycares` \
    linux-headers `#python_openzwave` \
    make \
    openssl-dev `#cryptography`

RUN adduser -D hass \
    && mkdir /config \
    && chown hass /config
VOLUME /config
USER hass
ENV PATH "/home/hass/.local/bin:${PATH}"

RUN pip install --user --no-cache-dir homeassistant-pyozw==0.1.2
COPY --chown=hass ./runtime-requirements.txt /tmp
RUN pip install --user --no-cache-dir --requirement /tmp/runtime-requirements.txt \
    && rm /tmp/runtime-requirements.txt

RUN pip install --user --no-cache-dir \
    homeassistant==0.85.1 \
    home-assistant-frontend==20190109.1

CMD ["python", "-m", "homeassistant", "--config", "/config"]
