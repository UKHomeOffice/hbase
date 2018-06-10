#!/bin/bash

DIR="$( cd "$(dirname "$0")" ; pwd -P )"
VERSION=1.4.4
DISTDIR="$DIR/../pontus-dist/opt/pontus/pontus-hbase";
TARFILE=$DIR/hbase-assembly/target/hbase-${VERSION}-bin.tar.gz

CURDIR=`pwd`
cd $DIR

echo DIR is $DIR
echo TARFILE is $TARFILE

if [[ ! -f $TARFILE ]]; then
  MAVEN_OPTS="-Xmx2g -Duser.language=en" LANG=en mvn install package assembly:single -DcompileSource=1.8 -Drat.numUnapprovedLicenses=100 -DskipTests  -Prelease -e
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

cat <<'EOF' >> start-zookeeper.sh
#!/bin/bash

kinit -kt /etc/security/keytabs/hbase.service.keytab hbase/`hostname -f`

pushd `dirname $0` > /dev/null
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export JAVA_HOME=/etc/alternatives/jre


cd $SCRIPTPATH
export HADOOP_HOME=$SCRIPTPATH
./bin/hbase zookeeper start
popd > /dev/null
EOF


cat << 'EOF' >> start-master.sh
#!/bin/bash

kinit -kt /etc/security/keytabs/hbase.service.keytab hbase/`hostname -f`

pushd `dirname $0` > /dev/null
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export JAVA_HOME=/etc/alternatives/jre

cd $SCRIPTPATH
export HADOOP_HOME=$SCRIPTPATH
./bin/hbase master --minRegionServers=1 --localRegionServers=1 --masters=1 start
popd > /dev/null

EOF

cat << 'EOF' >> start-regionserver.sh
#!/bin/bash

kinit -kt /etc/security/keytabs/hbase.service.keytab hbase/`hostname -f`

pushd `dirname $0` > /dev/null
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
export JAVA_HOME=/etc/alternatives/jre


cd $SCRIPTPATH
export HADOOP_HOME=$SCRIPTPATH
./bin/hbase regionserver start
popd > /dev/null

EOF

chmod 755 start-*.sh
cd $CURDIR
