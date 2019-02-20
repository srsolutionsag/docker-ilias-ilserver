FROM openjdk:8-jdk

WORKDIR /app

ENV ILSERVER_JAR=Services/WebServices/RPC/lib/ilServer.jar

ENV ILSERVER_DATA_PATH=data
ENV ILSERVER_ILIASDATA_PATH=iliasdata
ENV ILSERVER_INDEX_PATH=/var/lucenedata/ilias
ENV ILSERVER_PROPERTIES_PATH=ilServer.properties

RUN mkdir -p ${ILSERVER_DATA_PATH} ${ILSERVER_ILIASDATA_PATH} ${ILSERVER_INDEX_PATH} \
    && chown www-data:root ${ILSERVER_INDEX_PATH} \
    && chmod 775 ${ILSERVER_INDEX_PATH}
VOLUME ${ILSERVER_INDEX_PATH}

ENV ILIAS_VERSION=5.2.22
ENV ILIAS_SHA1=c480e0617a87e2e6b4bbbcb94ff6046c030043bb

RUN curl -o ilias.tar.gz -SL https://github.com/ILIAS-eLearning/ILIAS/archive/v${ILIAS_VERSION}.tar.gz \
    && echo "$ILIAS_SHA1 *ilias.tar.gz" | sha1sum -c - \
    && tar -xzf ilias.tar.gz --strip-components=1 --wildcards \
        */${ILSERVER_JAR} \
        */*/*/LuceneObjectDefinition.xml \
        */*/*/LuceneFileListDataSource.xml \
    && rm ilias.tar.gz

COPY docker-ilserver-entrypoint /usr/local/bin/

ENTRYPOINT ["docker-ilserver-entrypoint"]
CMD java -jar $ILSERVER_JAR $ILSERVER_PROPERTIES_PATH start
