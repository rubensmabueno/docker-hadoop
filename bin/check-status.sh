#!/usr/bin/env bash

set -o errexit

set -o errtrace

set -o nounset

set -o pipefail

set -o xtrace

_PORTS="50075 1006"
_URL_PATH="jmx?qry=Hadoop:service=DataNode,name=DataNodeInfo"
_CLUSTER_ID=""
for _PORT in $_PORTS; do
    _CLUSTER_ID+=$(curl -s http://localhost:${_PORT}/$_URL_PATH |  \
        grep ClusterId) || true
done
echo $_CLUSTER_ID | grep -q -v null
