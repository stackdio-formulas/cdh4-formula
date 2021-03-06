
# 
# Start the HBase master service
#

include:
  - cdh4.repo
  - cdh4.hadoop.client
  - cdh4.hbase.regionserver.hostnames
  - cdh4.zookeeper
  - cdh4.hbase.conf

{% if grains['os_family'] == 'Debian' %}
extend:
  remove_policy_file:
    file:
      - require:
        - service: hbase-master-svc
{% endif %}


hbase-init:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hdfs dfs -mkdir /hbase && hdfs dfs -chown hbase:hbase /hbase'
    - unless: 'hdfs dfs -test -d /hbase'
    - require:
      - pkg: hadoop-client

hbase-master-svc:
  service:
    - running
    - name: hbase-master
    - require: 
      - pkg: hbase-master
      - cmd: hbase-init
      - service: zookeeper-server
      - file: append_regionservers_etc_hosts
      - file: /etc/hbase/conf/hbase-site.xml
      - file: /etc/hbase/conf/hbase-env.sh
      - file: {{ pillar.cdh4.hbase.tmp_dir }}
      - file: {{ pillar.cdh4.hbase.log_dir }}
    - watch:
      - file: /etc/hbase/conf/hbase-site.xml
      - file: /etc/hbase/conf/hbase-env.sh

hbase-thrift-svc:
  cmd:
    - run
    - user: hbase
    - group: hbase
    - name: '/usr/lib/hbase/bin/hbase-daemon.sh start thrift'
    - unless: 'netstat -an | grep 9090'
