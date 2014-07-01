
/etc/default/impala:
  file:
    - managed
    - source: salt://cdh4/impala/defaults
    - template: jinja
    - makedirs: true
    - require:
      - pkg: impala

/etc/default/bigtop-utils:
  file:
    - managed
    - source: salt://cdh4/impala/bigtop-utils
    - template: jinja
    - makedirs: true
    - require:
      - pkg: impala

/etc/impala/conf/hive-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hive/hive-site.xml
    - require:
      - pkg: impala

/etc/impala/conf/core-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hadoop/conf/core-site.xml
    - require:
      - pkg: impala

/etc/impala/conf/hdfs-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hadoop/conf/hdfs-site.xml
    - require:
      - pkg: impala

/etc/impala/conf/hbase-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hbase/conf/hbase-site.xml
    - require:
      - pkg: impala
