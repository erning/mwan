#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

echo "ipset restore <<EOF"
echo "create NET_China hash:net -exist"
echo "flush NET_China"
cat "$DIR/feed/delegated-apnic-latest" | \
  awk -F '|' '$1=="apnic" && $2=="CN" && $3=="ipv4" {print $4"/"32-log($5)/log(2)}' | \
  aggregate | \
  awk '{print "add NET_China", $1}'
echo "EOF"