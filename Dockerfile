FROM python:3.7

ENV HASS_USER hass
ENV HASS_HOME "/home/${HASS_USER}"

RUN useradd --home-dir "$HASS_HOME" --create-home "$HASS_USER" \
    && chown hass:hass "$HASS_HOME"
USER "$HASS_USER"

ENV PATH "${HASS_HOME}/.local/bin:${PATH}"

COPY ./python-requirements.txt .
RUN pip install --user --no-cache-dir --requirement python-requirements.txt

EXPOSE 8123
CMD ["python", "-m", "homeassistant"]
