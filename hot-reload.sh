#!/bin/bash

set -e

TOMCAT_HOME=/usr/local/tomcat
TOMCAT_ROOT=$TOMCAT_HOME/webapps/ROOT

WATCH_DIR=/app/src
TMP_DIR=/app/tmp
TMP_SRC=$TMP_DIR/src

coproc INO {
  inotifywait -m -r -e modify,create,delete --format '%w%f' $WATCH_DIR
}

while read -u "${INO[0]}" -r CHANGED_FILE; do
  echo "=== source changed, rebuilding... ==="
  echo "changed file: $CHANGED_FILE"

  rsync -a --delete --exclude "WEB-INF/classes" $WATCH_DIR/ $TMP_SRC/

  if [ "${CHANGED_FILE##*.}" = "java" ]; then
    echo "recompiling..."

    rm -rf $TMP_SRC/main/webapp/WEB-INF/classes

    find $TMP_SRC/main/java -name '*.java' |
      xargs javac -classpath $TOMCAT_HOME/lib/servlet-api.jar -d $TMP_SRC/main/webapp/WEB-INF/classes || true
  fi

  rsync -a --delete $TMP_SRC/main/webapp/ $TOMCAT_ROOT/

  echo "=== rebuild done ==="
done
