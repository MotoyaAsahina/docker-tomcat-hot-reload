#!/bin/bash

set -e

cd /app

TOMCAT_HOME=/usr/local/tomcat
TOMCAT_ROOT=$TOMCAT_HOME/webapps/ROOT

# マウントした src/main/webapp 内に class ファイルを作成しないため
mkdir -p tmp
rsync -a src/ tmp/src/
cd tmp

dirs=(
  "$TOMCAT_ROOT"
  src/main/webapp/WEB-INF
  src/main/webapp/WEB-INF/classes
)

for d in "${dirs[@]}"; do
  mkdir -p "$d"
done

find src/main/java -name '*.java' |
  xargs javac -classpath $TOMCAT_HOME/lib/servlet-api.jar:'src/main/webapp/WEB-INF/lib/*' \
    -d src/main/webapp/WEB-INF/classes

rsync -a src/main/webapp/ $TOMCAT_ROOT/

# sed -i 's#<Context>#<Context reloadable="true">#g' $TOMCAT_HOME/conf/context.xml
cp /app/context.xml $TOMCAT_HOME/conf/context.xml
