#!/usr/bin/env bash

set -o errexit

set -o errtrace

set -o nounset

set -o pipefail

set -o xtrace
_HDFS_BIN=$HADOOP_PREFIX/bin/hdfs
_METADATA_DIR=/hadoop/dfs/name/current
if [[ "$MY_POD" = "$NAMENODE_POD_0" ]]; then
    if [[ ! -d $_METADATA_DIR ]]; then
        $_HDFS_BIN --config $HADOOP_CONF_DIR namenode -format  \
            -nonInteractive hdfs-k8s ||
            (rm -rf $_METADATA_DIR; exit 1)
    fi
    _ZKFC_FORMATTED=/hadoop/dfs/name/current/.hdfs-k8s-zkfc-formatted
    if [[ ! -f $_ZKFC_FORMATTED ]]; then
    _OUT=$($_HDFS_BIN --config $HADOOP_CONF_DIR zkfc -formatZK -nonInteractive 2>&1)
    # zkfc masks fatal exceptions and returns exit code 0
    (echo $_OUT | grep -q "FATAL") && exit 1
    touch $_ZKFC_FORMATTED
    fi
elif [[ "$MY_POD" = "$NAMENODE_POD_1" ]]; then
    if [[ ! -d $_METADATA_DIR ]]; then
    $_HDFS_BIN --config $HADOOP_CONF_DIR namenode -bootstrapStandby  \
        -nonInteractive ||  \
        (rm -rf $_METADATA_DIR; exit 1)
    fi
fi
$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR start zkfc
$_HDFS_BIN --config $HADOOP_CONF_DIR namenode