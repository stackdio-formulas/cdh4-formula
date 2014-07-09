include:
  - cdh4.repo
  - cdh4.impala.conf
{% if salt['pillar.get']('cdh4:impala:start_service', True) %}
  - cdh4.impala.state-store.service
{% endif %}

impala-state-store-install:
  pkg:
    - installed
    - pkgs:
      - impala
      - impala-catalog
      - impala-state-store
      - impala-shell
    - require:
      - module: cdh4_refresh_db
    - require_in:
      - file: /etc/default/impala
      - file: /etc/default/bigtop-utils
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      {% if 'cdh4.hbase.master' in grains['roles'] or 'cdh4.hbase.regionserver' in grains['roles'] %}
      - file: /etc/impala/conf/hbase-site.xml
      {% endif %}
