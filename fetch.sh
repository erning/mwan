#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

ISPS=(all_cn chinatelecom unicom_cnc cmcc crtc cernet gwbn othernet)

for ISP in ${ISPS[*]}
do
  curl "https://ispip.clang.cn/$ISP.txt" -o "$DIR/feed/$ISP.txt"
done
