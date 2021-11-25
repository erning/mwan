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
echo "IPSET='/sbin/ipset'"
echo ""

echo '$IPSET restore <<EOF'
echo "create cn-network hash:net -exist"
echo "flush cn-network"
cat "$DIR/feed/delegated-apnic-latest" | \
  awk -F '|' '$1=="apnic" && $2=="CN" && $3=="ipv4" {print $4"/"32-log($5)/log(2)}' | \
  aggregate | \
  awk '{print "add cn-network", $1}'
echo ""
# cat "$DIR/ip-lists/china.txt" | \
#   aggregate | \
#   awk '{print "add cn-network", $1}'
# echo ""


#
# ChinaTelecom
#
ISPS=(chinanet googlecn)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/ip-lists/$ISP.txt")
done

echo "create ct-network hash:net -exist"
echo "flush ct-network"
cat ${FILES[*]} | aggregate | awk '{print "add ct-network", $1}'
echo ""


#
# Others
#
ISPS=(cmcc cernet cstnet drpeng tietong unicom)

FILES=()
for ISP in ${ISPS[*]}
do
  FILES+=("$DIR/ip-lists/$ISP.txt")
done

echo "create cm-network hash:net -exist"
echo "flush cm-network"
cat ${FILES[*]} | aggregate | awk '{print "add cm-network", $1}'
echo ""

echo "EOF"
echo ""
