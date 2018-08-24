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

echo "ipset restore <<EOF"
echo "create NET_ChinaTelecom hash:net -exist"
echo "flush NET_ChinaTelecom"
cat ${FILES[*]} | aggregate | awk '{print "add NET_ChinaTelecom", $1}'
echo "EOF"

#
# Via ChinaMobile - Unifi (172.31.17.1)
#
ISPS=(unicom_cnc cmcc crtc cernet gwbn)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/feed/$ISP.txt")
done

echo "ipset restore <<EOF"
echo "create NET_ChinaMobile hash:net -exist"
echo "flush NET_ChinaMobile"
cat ${FILES[*]} | aggregate | awk '{print "add NET_ChinaMobile", $1}'
echo "EOF"

