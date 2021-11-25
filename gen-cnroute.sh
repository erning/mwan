#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

#
# China Network
#
echo "#!/bin/bash"
echo ""
echo "IP='/sbin/ip'"
echo ""

cat "$DIR/ip-lists/china.txt" | \
  awk '{print "ip route add", $0, "via 192.168.8.1 table 100"}'
echo ""

