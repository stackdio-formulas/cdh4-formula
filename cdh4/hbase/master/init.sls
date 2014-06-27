
#
# Install the HBase master package
#

include:
  - cdh4.repo
  - cdh4.hadoop.client
  - cdh4.zookeeper
  - cdh4.hbase.conf
{% if salt['pillar.get']('cdh4:hbase:start_service', True) %}
  - cdh4.hbase.master.service
{% endif %}

extend:
  /etc/hbase/conf/hbase-site.xml:
    file:
      - require:
        - pkg: hbase-master
  /etc/hbase/conf/hbase-env.sh:
    file:
      - require:
        - pkg: hbase-master
  {{ pillar.cdh4.hbase.tmp_dir }}:
    file:
      - require:
        - pkg: hbase-master
  {{ pillar.cdh4.hbase.log_dir }}:
    file:
      - require:
        - pkg: hbase-master

hbase-master:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db


