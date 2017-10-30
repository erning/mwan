#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#
# Via ChinaTelecom - Cisco (172.31.17.2)
#
ISPS=(chinatelecom othernet)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/feed/$ISP.txt")
done

echo "ip -batch - <<EOF"
cat ${FILES[*]} | aggregate | awk '{print "  route add", $1, "via 172.31.17.2"}'
echo "EOF"

#
# Via ChinaMobile - Unifi (172.31.17.1)
#
ISPS=(unicom_cnc cmcc crtc cernet gwbn)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/feed/$ISP.txt")
  echo $ISP
done

echo "ip -batch - <<EOF"
cat ${FILES[*]} | aggregate | awk '{print "  route add", $1, "via 172.31.17.1"}'
echo "EOF"
