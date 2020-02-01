ARG HOME_ASSISTANT_VERSION=0.104.3
FROM homeassistant/home-assistant:$HOME_ASSISTANT_VERSION

# inherited:
# CMD ["python3", "-m", "homeassistant", "--config", "/config"]

# not inherited:
EXPOSE 8123/tcp

# why do the home assistant maintainers run their containers as root?!
RUN python3 -c 'import os; assert os.geteuid() == 0, "finally..."' \
    && find / -xdev -type f -perm /u+s -exec chmod -c u-s {} \; \
    && find / -xdev -type f -perm /g+s -exec chmod -c g-s {} \; \
    && adduser -D hass \
    && chown hass /config
VOLUME /config
USER hass
