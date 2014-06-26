
# 
# Install the Zookeeper package
# 

include:
  - cdh4.repo
{% if salt['pillar.get']('cdh4:zookeeper:start_service', True) %}
  - cdh4.zookeeper.service
{% endif %}

zookeeper:
  pkg:
    - installed
    - require:
      - module: cdh4_refresh_db

zookeeper-server:
  pkg:
    - installed
    - require:
      - pkg: zookeeper

/etc/zookeeper/conf/log4j.properties:
  file:
    - replace
    - pattern: 'maxbackupindex=20'
    - repl: 'maxbackupindex={{ pillar.cdh4.max_log_index }}'
    - require:
      - pkg: zookeeper-server

