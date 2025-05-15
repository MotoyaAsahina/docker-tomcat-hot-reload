#!/bin/bash

set -e

TOMCAT_HOME=/usr/local/tomcat
TOMCAT_ROOT=$TOMCAT_HOME/webapps/ROOT

WATCH_DIR=/app/src
TMP_DIR=/app/tmp
TMP_SRC=$TMP_DIR/src

while inotifywait -r -e modify,create,delete ${WATCH_DIR}; do
  echo "=== source changed, rebuilding... ==="

  # cp -r $WATCH_DIR $TMP_DIR
  rsync -a --delete $WATCH_DIR/ $TMP_SRC/

  # rm -rf $TMP_SRC/main/webapp/WEB-INF/classes/*

  find $TMP_SRC/main/java -name '*.java' |
    xargs javac -classpath $TOMCAT_HOME/lib/servlet-api.jar -d $TMP_SRC/main/webapp/WEB-INF/classes || true

  rsync -a --delete $TMP_SRC/main/webapp/ $TOMCAT_ROOT/

  echo "=== rebuild done ==="
done
