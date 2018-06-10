#
#/**
# * Licensed to the Apache Software Foundation (ASF) under one
# * or more contributor license agreements.  See the NOTICE file
# * distributed with this work for additional information
# * regarding copyright ownership.  The ASF licenses this file
# * to you under the Apache License, Version 2.0 (the
# * "License"); you may not use this file except in compliance
# * with the License.  You may obtain a copy of the License at
# *
# *     http://www.apache.org/licenses/LICENSE-2.0
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# */

# Set environment variables here.

# This script sets variables multiple times over the course of starting an hbase process,
# so try to keep things idempotent unless you want to take an even deeper look
# into the startup scripts (bin/hbase, etc.)

# The java implementation to use.  Java 1.7+ required.
# export JAVA_HOME=/usr/java/jdk1.6.0/

# Extra Java CLASSPATH elements.  Optional.
# export HBASE_CLASSPATH=

# The maximum amount of heap to use. Default is left to JVM default.
# export HBASE_HEAPSIZE=1G

# Uncomment below if you intend to use off heap cache. For example, to allocate 8G of 
# offheap, set the value to "8G".
# export HBASE_OFFHEAPSIZE=1G

# Extra Java runtime options.
# Below are what we set by default.  May only work with SUN JVM.
# For more on why as well as other possible settings,
# see http://wiki.apache.org/hadoop/PerformanceTuning
#export HBASE_OPTS="-XX:+UseConcMarkSweepGC -Djava.security.auth.login.config=/opt/pontus/pontus-hbase/current/conf/hbase_regionserver_jaas.conf -Djava.security.auth.login.config=/opt/pontus/pontus-hbase/current/conf/hbase_client_jaas.conf -Djavax.security.auth.useSubjectCredsOnly=false  -Dhbase.id.str=hbase"

# Configure PermSize. Only needed in JDK7. You can safely remove it for JDK8+
export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -XX:PermSize=128m -XX:MaxPermSize=128m"
export HBASE_REGIONSERVER_OPTS=" \
 $HBASE_REGIONSERVER_OPTS  \
 -XX:PermSize=128m  \
 -XX:MaxPermSize=128m  \
 -Dkafka.security.auth.login.config=/opt/pontus/pontus-hbase/current/conf/hbase-kafka-jaas.conf \
 -Dkafka.security.protocol=SASL_SSL \
 -Dssl.truststore.location=/etc/pki/java/truststore.jks \
 -Dssl.truststore.password=changeit \
 -Dssl.keystore.location=/etc/pki/java/localhost.jks \
 -Dssl.keystore.password=pa55word \
 -Dssl.key.password=pa55word \
 -Dsasl.kerberos.service.name="kafka" \
 -Dkafka.bootstrap.servers=pontus-sandbox.pontusvision.com:9092 \
 -Dkafka.enable.auto.commit=true \
 -Dkafka.auto.commit.interval.ms=10000 \
 "

# Uncomment one of the below three options to enable java garbage collection logging for the server-side processes.

# This enables basic gc logging to the .out file.
# export SERVER_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps"

# This enables basic gc logging to its own file.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export SERVER_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH>"

# This enables basic GC logging to its own file with automatic log rolling. Only applies to jdk 1.6.0_34+ and 1.7.0_2+.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export SERVER_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH> -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=1 -XX:GCLogFileSize=512M"

# Uncomment one of the below three options to enable java garbage collection logging for the client processes.

# This enables basic gc logging to the .out file.
# export CLIENT_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps"

# This enables basic gc logging to its own file.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export CLIENT_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH>"

# This enables basic GC logging to its own file with automatic log rolling. Only applies to jdk 1.6.0_34+ and 1.7.0_2+.
# If FILE-PATH is not replaced, the log file(.gc) would still be generated in the HBASE_LOG_DIR .
# export CLIENT_GC_OPTS="-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -Xloggc:<FILE-PATH> -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=1 -XX:GCLogFileSize=512M"

# See the package documentation for org.apache.hadoop.hbase.io.hfile for other configurations
# needed setting up off-heap block caching. 

# Uncomment and adjust to enable JMX exporting
# See jmxremote.password and jmxremote.access in $JRE_HOME/lib/management to configure remote password access.
# More details at: http://java.sun.com/javase/6/docs/technotes/guides/management/agent.html
# NOTE: HBase provides an alternative JMX implementation to fix the random ports issue, please see JMX
# section in HBase Reference Guide for instructions.

# export HBASE_JMX_BASE="-Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
# export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10101"
# export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10102"
# export HBASE_THRIFT_OPTS="$HBASE_THRIFT_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10103"
# export HBASE_ZOOKEEPER_OPTS="$HBASE_ZOOKEEPER_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10104"
# export HBASE_REST_OPTS="$HBASE_REST_OPTS $HBASE_JMX_BASE -Dcom.sun.management.jmxremote.port=10105"

# File naming hosts on which HRegionServers will run.  $HBASE_HOME/conf/regionservers by default.
# export HBASE_REGIONSERVERS=${HBASE_HOME}/conf/regionservers

# Uncomment and adjust to keep all the Region Server pages mapped to be memory resident
#HBASE_REGIONSERVER_MLOCK=true
#HBASE_REGIONSERVER_UID="hbase"

# File naming hosts on which backup HMaster will run.  $HBASE_HOME/conf/backup-masters by default.
# export HBASE_BACKUP_MASTERS=${HBASE_HOME}/conf/backup-masters

# Extra ssh options.  Empty by default.
# export HBASE_SSH_OPTS="-o ConnectTimeout=1 -o SendEnv=HBASE_CONF_DIR"

# Where log files are stored.  $HBASE_HOME/logs by default.
# export HBASE_LOG_DIR=${HBASE_HOME}/logs

# Enable remote JDWP debugging of major HBase processes. Meant for Core Developers 
# export HBASE_MASTER_OPTS="$HBASE_MASTER_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8070"
# export HBASE_REGIONSERVER_OPTS="$HBASE_REGIONSERVER_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8071"
# export HBASE_THRIFT_OPTS="$HBASE_THRIFT_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8072"
# export HBASE_ZOOKEEPER_OPTS="$HBASE_ZOOKEEPER_OPTS -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8073"

# A string representing this instance of hbase. $USER by default.
# export HBASE_IDENT_STRING=$USER

# The scheduling priority for daemon processes.  See 'man nice'.
# export HBASE_NICENESS=10

# The directory where pid files are stored. /tmp by default.
# export HBASE_PID_DIR=/var/hadoop/pids

# Seconds to sleep between slave commands.  Unset by default.  This
# can be useful in large clusters, where, e.g., slave rsyncs can
# otherwise arrive faster than the master can service them.
# export HBASE_SLAVE_SLEEP=0.1

# Tell HBase whether it should manage it's own instance of Zookeeper or not.
# export HBASE_MANAGES_ZK=true

# The default log rolling policy is RFA, where the log file is rolled as per the size defined for the 
# RFA appender. Please refer to the log4j.properties file to see more details on this appender.
# In case one needs to do log rolling on a date change, one should set the environment property
# HBASE_ROOT_LOGGER to "<DESIRED_LOG LEVEL>,DRFA".
# For example:
# HBASE_ROOT_LOGGER=INFO,DRFA
# The reason for changing default to RFA is to avoid the boundary case of filling out disk space as 
# DRFA doesn't put any cap on the log size. Please refer to HBase-5655 for more context.

export CLIENT_CONF=/opt/pontus/pontus-hbase/current/conf/client.jaas
export HBASE_SERVER_CONF=/opt/pontus/pontus-hbase/current/conf/server.jaas
export HBASE_REGION_SERVER_CONF=/opt/pontus/pontus-hbase/current/conf/region-server.jaas
export HBASE_OPTS="-Djava.security.auth.login.config=$CLIENT_CONF"
export HBASE_MANAGES_ZK=true
export HBASE_ZOOKEEPER_OPTS="-Djava.security.auth.login.config=$HBASE_SERVER_CONF -Dsun.security.krb5.debug=false"
#export HBASE_MASTER_OPTS="-Djava.security.auth.login.config=$HBASE_SERVER_CONF  -Dhbase.id.str=hbase/pontus-sandbox.pontusvision.com@PONTUSVISION.COM -Djava.security.krb5.kdc=pontus-sandbox.pontusvision.com -Djava.security.krb5.realm=PONTUSVISION.COM  -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5006 -Dsun.security.krb5.debug=true"
export HBASE_MASTER_OPTS="-Djava.security.auth.login.config=$HBASE_SERVER_CONF  -Dhbase.id.str=hbase/pontus-sandbox.pontusvision.com@PONTUSVISION.COM -Djava.security.krb5.kdc=pontus-sandbox.pontusvision.com -Djava.security.krb5.realm=PONTUSVISION.COM"
#export HBASE_REGIONSERVER_OPTS="-Djava.security.auth.login.config=$HBASE_REGION_SERVER_CONF  -Dhbase.id.str=hbase/pontus-sandbox.pontusvision.com@PONTUSVISION.COM -Djava.security.krb5.kdc=pontus-sandbox.pontusvision.com -Djava.security.krb5.realm=PONTUSVISION.COM  -agentlib:jdwp=transport=dt_socket,server=y,suspend=y,address=5006 -Dsun.security.krb5.debug=true"
export HBASE_REGIONSERVER_OPTS=" \
 -Djava.security.auth.login.config=$HBASE_REGION_SERVER_CONF  \
 -Dhbase.id.str=hbase/pontus-sandbox.pontusvision.com@PONTUSVISION.COM  \
 -Djava.security.krb5.kdc=pontus-sandbox.pontusvision.com  \
 -Djava.security.krb5.realm=PONTUSVISION.COM   \
 -Dsun.security.krb5.debug=false \
 $HBASE_REGIONSERVER_OPTS  \
 -XX:PermSize=128m  \
 -XX:MaxPermSize=128m  \
 -Dkafka.security.auth.login.config=/opt/pontus/pontus-hbase/current/conf/hbase-kafka-jaas.conf \
 -Dkafka.security.protocol=SASL_SSL \
 -Dkafka.ssl.truststore.location=/etc/pki/java/truststore.jks \
 -Dkafka.ssl.truststore.password=changeit \
 -Dkafka.ssl.keystore.location=/etc/pki/java/localhost.jks \
 -Dkafka.ssl.keystore.password=pa55word \
 -Dkafka.ssl.key.password=pa55word \
 -Dkafka.sasl.kerberos.service.name="kafka" \
 -Dkafka.bootstrap.servers=pontus-sandbox.pontusvision.com:9092 \
 -Dkafka.enable.auto.commit=true \
 -Dkafka.auto.commit.interval.ms=10000 \
 -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5009 \
 "


