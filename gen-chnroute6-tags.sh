#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#
# ChinaTelecom
#
ISPS=(chinatelecom)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/feed/${ISP}_ipv6.txt")
done

cat ${FILES[*]} > "chnroute-ct.ipv6"

#
# Others
#
ISPS=(unicom_cnc cmcc crtc cernet gwbn othernet)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/feed/${ISP}_ipv6.txt")
done

cat ${FILES[*]} > "chnroute-cm.ipv6"

