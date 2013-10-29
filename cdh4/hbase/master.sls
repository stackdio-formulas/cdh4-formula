{% set hbase_tmp_dir = salt['pillar.get']('cdh4:hbase:tmp_dir', '/mnt/hbase/tmp') %}
{% set zk_data_dir = salt['pillar.get']('cdh4:zookeeper:data_dir', '/mnt/zk/data') %}

include:
  - cdh4.repo
  - cdh4.hadoop.client
  - cdh4.hbase.regionserver_hostnames
  - cdh4.zookeeper
  - cdh4.hbase.conf

hbase-init:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hadoop fs -mkdir /hbase && hadoop fs -chown hbase:hbase /hbase'
    - unless: 'hadoop fs -test -d /hbase'
    - require:
      - pkg: hadoop-client

hbase-master:
  pkg:
    - installed 
    - require:
      - cmd: hbase-init
      - service.running: zookeeper-start
      - service.running: zookeeper-server
      - file: append_regionservers_etc_hosts
  service:
    - running
    - require: 
      - pkg: hbase-master
      - file: master_hbase_site
    - watch:
      - file: master_hbase_site

master_hbase_site:
  file:
    - managed
    - name: /etc/hbase/conf/hbase-site.xml
    - source: salt://cdh4/etc/hbase/conf/hbase-site.xml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: hbase-master
