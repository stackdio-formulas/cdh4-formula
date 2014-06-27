include:
  - cdh4.repo
{% if salt['pillar.get']('cdh4:impala:start_service', True) %}
  - cdh4.impala.service
{% endif %}

impala:
  pkg:
    - installed
    - pkgs:
      - impala
      - impala-catalog
      - impala-state-store
      - impala-server
      - impala-shell
    - require:
      - module: cdh4_refresh_db

/etc/default/impala:
  file:
    - managed
    - source: salt://cdh4/impala/defaults
    - template: jinja
    - makedirs: true

/etc/default/bigtop-utils:
  file:
    - managed
    - source: salt://cdh4/impala/bigtop-utils
    - template: jinja
    - makedirs: true

/etc/impala/conf/hive-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hive/hive-site.xml

/etc/impala/conf/core-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hadoop/conf/core-site.xml

/etc/impala/conf/hdfs-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hadoop/conf/hdfs-site.xml

/etc/impala/conf/hbase-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hbase/conf/hbase-site.xml


