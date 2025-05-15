#!/bin/bash

set -e

chmod +x /init-build.sh /hot-reload.sh

/init-build.sh

catalina.sh run &

exec /hot-reload.sh
