#/bin/bash

echo "ip -batch - <<EOF"
netstat -nr | awk '$1 !~ /^0\./ && $1 !~ /^192\.168\./ && $1 !~ /^172\.[123][678901]\./ && $1 !~ /^10\./ && $3 ~ /\.0$/ {print "  route del", $1"/"$3}'
echo "EOF"
