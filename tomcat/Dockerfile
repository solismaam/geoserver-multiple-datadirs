ARG TOMCAT_IMAGE_TAG

FROM tomcat:${TOMCAT_IMAGE_TAG:?}

ARG SERVICE_NAME
ARG USER=tomcat
ARG USER_UID=1000
ARG USER_GID=1000

ENV SERVICE_NAME=${SERVICE_NAME:?}

RUN addgroup --gid ${USER_GID} ${USER}
RUN adduser \
    --gecos Tomcat \
    --gid ${USER_GID} \
    --home ${CATALINA_HOME} \
    --no-create-home \
    --shell /bin/bash \
    --uid ${USER_UID} \
    ${USER}

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt --quiet update \
    && apt --assume-yes --quiet install \
        fontconfig \
        less \
        libfreetype6 \
    && apt --assume-yes --quiet autoremove \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf ${CATALINA_HOME}/webapps.dist

COPY services/${SERVICE_NAME}/bin/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY geoserver.git/src/web/app/target/geoserver ${CATALINA_HOME}/webapps/geoserver

RUN chmod +x /usr/bin/docker-entrypoint.sh

RUN chown --recursive ${USER}:${USER} ${CATALINA_HOME}

USER ${USER}

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 8080

CMD ["catalina.sh", "run"]