#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
VERSION=1.3.1
DISTDIR="$DIR/../pontus-dist/opt/pontus/pontus-hbase";
TARFILE=$DIR/hbase-assembly/target/hbase-${VERSION}-bin.tar.gz

CURDIR=`pwd`
cd $DIR

echo DIR is $DIR
echo TARFILE is $TARFILE

if [[ ! -f $TARFILE ]]; then
  MAVEN_OPTS="-Xmx2g -Duser.language=en" LANG=en mvn install package assembly:single -Drat.numUnapprovedLicenses=100 -DskipTests  -Prelease -e
fi

if [[ ! -d $DISTDIR ]]; then
  mkdir -p $DISTDIR
fi

cd $DISTDIR
rm -rf *
tar xvfz $TARFILE
ln -s hbase-$VERSION current
cd current

cp -r ${DIR}/conf .

cat <<'EOF' >> start-hbase.sh
#!/bin/bash

kinit -kt /etc/security/keytabs/hbase.service.keytab hbase/`hostname -f`

pushd `dirname $0` > /dev/null
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

cd $SCRIPTPATH
export HADOOP_HOME=$SCRIPTPATH
./bin/hbase zookeeper start&
export PIDSTOWAIT=$!
sleep 3;
./bin/hbase master --minRegionServers=1 --localRegionServers=1 --masters=1 start&
export PIDSTOWAIT="$PIDSTOWAIT $!"
sleep 3;
./bin/hbase regionserver start&
export PIDSTOWAIT="$PIDSTOWAIT $!"
wait $PIDSTOWAIT
popd > /dev/null

EOF

chmod 755 start-hbase.sh
cd $CURDIR
