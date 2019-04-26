ARG JAVA_VERSION

FROM openjdk:${JAVA_VERSION}

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

ENV ILIAS_VERSION=5.4.1
ENV ILIAS_SHA1=26eab62273d96174c96203577a798ec0e89dd661

RUN curl -o ilias.tar.gz -SL https://github.com/ILIAS-eLearning/ILIAS/archive/v${ILIAS_VERSION}.tar.gz \
    && echo "$ILIAS_SHA1 *ilias.tar.gz" | sha1sum -c - \
    && tar -xzf ilias.tar.gz --strip-components=1 --wildcards \
        */${ILSERVER_JAR} \
        */*/*/*.xml \
    && rm ilias.tar.gz

COPY docker-ilserver-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-ilserver-entrypoint"]
CMD java -jar $ILSERVER_JAR $ILSERVER_PROPERTIES_PATH start
