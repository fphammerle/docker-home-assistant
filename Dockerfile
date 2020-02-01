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

# no wheels available for homeassistant-pyozw
# https://pypi.org/project/homeassistant-pyozw/0.1.2/#files
RUN pip install --user --no-cache-dir homeassistant-pyozw==0.1.2
# https://github.com/home-assistant/home-assistant/blob/0.89.0/requirements_all.txt
COPY --chown=hass ./runtime-requirements.txt /tmp
RUN pip install --user --no-cache-dir --requirement /tmp/runtime-requirements.txt \
    && rm /tmp/runtime-requirements.txt

RUN pip install --user --no-cache-dir \
    homeassistant==0.89.0 \
    home-assistant-frontend==20190305.0

CMD ["python", "-m", "homeassistant", "--config", "/config"]
