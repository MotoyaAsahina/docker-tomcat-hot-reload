#!/bin/bash

set -e

/init-build.sh

catalina.sh run &

exec /hot-reload.sh
