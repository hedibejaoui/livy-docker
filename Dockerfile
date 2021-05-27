FROM sterbene/hadoop-hive-spark:3.0.1

ARG LIVY_VERSION=0.8.0-incubating-SNAPSHOT
ENV LIVY_HOME /usr/livy
ENV LIVY_CONF_DIR "${LIVY_HOME}/conf"
RUN curl --progress-bar -L --retry 3 \
    "https://github.com/hedibejaoui/livy-docker/releases/download/0.8.0/apache-livy-${LIVY_VERSION}-bin.zip" \
    -o "./apache-livy-${LIVY_VERSION}-bin.zip" \
  && unzip -qq "./apache-livy-${LIVY_VERSION}-bin.zip" -d /usr \
  && mv "/usr/apache-livy-${LIVY_VERSION}-bin" "${LIVY_HOME}" \
  && rm -rf "./apache-livy-${LIVY_VERSION}-bin.zip" \
  && mkdir "${LIVY_HOME}/logs" \
  && chown -R root:root "${LIVY_HOME}"

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

HEALTHCHECK CMD curl -f "http://host.docker.internal:${LIVY_PORT}/" || exit 1

ENTRYPOINT ["/entrypoint.sh"]
