ARG JAVA_VERSION
ARG ILIAS_BRANCH

FROM srsolutions/ilias:${ILIAS_BRANCH} AS ilias

FROM eclipse-temurin:${JAVA_VERSION}

WORKDIR /app

ENV ILSERVER_PORT=11111
ENV ILSERVER_JAR=Services/WebServices/RPC/lib/ilServer.jar

ENV ILSERVER_DATA_PATH=data
ENV ILSERVER_ILIASDATA_PATH=iliasdata
ENV ILSERVER_INDEX_PATH=/var/lucenedata/ilias
ENV ILSERVER_PROPERTIES_PATH=ilServer.properties

RUN mkdir -p ${ILSERVER_DATA_PATH} ${ILSERVER_ILIASDATA_PATH} ${ILSERVER_INDEX_PATH}
VOLUME ${ILSERVER_INDEX_PATH}

EXPOSE $ILSERVER_PORT

COPY --from=ilias /var/www/html/Modules ./Modules
COPY --from=ilias /var/www/html/Services ./Services

COPY docker-ilserver-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-ilserver-entrypoint"]
CMD java -jar $ILSERVER_JAR $ILSERVER_PROPERTIES_PATH start
