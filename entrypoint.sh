#!/bin/bash

if [[ "$2" == *"namenode"* ]]; then
  # Check if the HDFS Namenode has already been formatted
  if [ ! -f /hadoop/dfs/name/current/VERSION ]; then
    # Format HDFS Namenode
    echo "Formatting HDFS Namenode..."
    $HADOOP_HOME/bin/hdfs namenode -format -force
  fi
fi

# Keep the container running
exec $@
