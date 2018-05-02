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

cat <<'EOF' >> start-hbase.sh
#!/bin/bash

pushd `dirname $0` > /dev/null
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
popd > /dev/null
kinit -kt /etc/security/keytabs/hbase.service.keytab hbase/`hostname -f`
export HADOOP_HOME=$SCRIPTPATH
./bin/hbase master --minRegionServers=1 --localRegionServers=1 --masters=1 start
EOF

chmod 755 start-hbase.sh
cd $CURDIR
