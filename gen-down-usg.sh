#/bin/bash

echo "ip -batch - <<EOF"
netstat -nr | awk '$2=="172.31.17.2" {print "  route del", $1"/"$3}'
echo "EOF"
