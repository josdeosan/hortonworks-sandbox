# Licensed to Hortonworks, Inc. under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Hortonworks, Inc. licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#HOME="/home/hadoop"
#HOME1="/home"
line="50"

#------- Start script ---------
echo "Starting Postgresql"
/etc/init.d/postgresql start
sleep 5
echo "Start name node"
su - hdfs -c "/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start namenode";sleep 5
tail -$line  /var/log/hadoop/hdfs/hadoop-hdfs-namenode-*.log

echo "Start data node"
su - hdfs -c "/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start datanode";sleep 5
tail -$line  /var/log/hadoop/hdfs/hadoop-hdfs-datanode-*.log

echo "Start secondary name node"
su - hdfs -c "/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start secondarynamenode";sleep 5
tail -$line  /var/log/hadoop/hdfs/hadoop-hdfs-secondarynamenode-*.log

echo "Start job tracker"
su - mapred -c "/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start jobtracker; sleep 25"
tail -$line  /var/log/hadoop/mapred/hadoop-mapred-jobtracker-*.log

echo "Start history server"
su - mapred -c "/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start historyserver";sleep 5
tail -$line  /var/log/hadoop/mapred/hadoop-mapred-historyserver-*.log

echo "Start task trackers"
su mapred -c "/usr/lib/hadoop/bin/hadoop-daemon.sh --config /etc/hadoop/conf start tasktracker";sleep 5
tail -$line  /var/log/hadoop/mapred/hadoop-mapred-tasktracker-*.log

echo "Start zookeeper nodes"
su - zookeeper -c  'source /etc/zookeeper/conf/zookeeper-env.sh ; /bin/env ZOOCFGDIR=/etc/zookeeper/conf ZOOCFG=zoo.cfg /usr/lib/zookeeper/bin/zkServer.sh start'

echo "Start hbase master"
su - hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start master; sleep 25"
tail -$line  /var/log/hbase/hbase-hbase-master-*.log

echo "Start hbase regionservers"
su - hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh --config /etc/hbase/conf start regionserver";sleep 5
tail -$line  /var/log/hbase/hbase-hbase-regionserver-*.log

echo "Start hcat server"
/etc/init.d/mysqld start
su - hive -c  'env HADOOP_HOME=/usr nohup hive --service metastore > /var/log/hive/hive.out 2> /var/log/hive/hive.log & '
tail -$line  /var/log/hive/hive.log

echo "Start Hiveserver2"
su - hive -c  'env HADOOP_HOME=/usr nohup hive --service hiveserver2 > /var/log/hive/hive.out 2> /var/log/hive/hive.log & '
tail -$line  /var/log/hive/hive.log

echo "Start templeton server"
su - hcat -c '/usr/lib/hcatalog/sbin/webhcat_server.sh start'
tail -$line  /var/log/webhcat/webhcat.log

echo "Start Oozie"
su - oozie -c "cd /var/log/oozie; /usr/lib/oozie/bin/oozie-start.sh"
tail -$line  /var/log/oozie/oozie.log

echo "Service associated with port"
netstat -nltp

echo "*********************************************"

echo "Java Process"
ps auxwwwf | grep java | grep -v grep | awk '{print $1, $11,$12}'

