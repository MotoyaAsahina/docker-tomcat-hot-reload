FROM tomcat:10-jdk21

USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends inotify-tools rsync && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh
COPY init-build.sh /init-build.sh
COPY hot-reload.sh /hot-reload.sh
RUN chmod +x /entrypoint.sh /init-build.sh /hot-reload.sh

COPY context.xml /app/context.xml

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
