
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

