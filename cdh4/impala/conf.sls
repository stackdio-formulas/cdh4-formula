
/etc/default/impala:
  file:
    - managed
    - source: salt://cdh4/impala/defaults
    - template: jinja
    - makedirs: true
    - require:
      {% if 'cdh4.impala.server' in grains['roles'] %}
      - pkg: impala-server-install
      {% endif %}
      {% if 'cdh4.impala.state-store' in grains['roles'] %}
      - pkg: impala-state-store-install
      {% endif %}

/etc/default/bigtop-utils:
  file:
    - managed
    - source: salt://cdh4/impala/bigtop-utils
    - template: jinja
    - makedirs: true
    - require:
      {% if 'cdh4.impala.server' in grains['roles'] %}
      - pkg: impala-server-install
      {% endif %}
      {% if 'cdh4.impala.state-store' in grains['roles'] %}
      - pkg: impala-state-store-install
      {% endif %}

/etc/impala/conf/hive-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hive/hive-site.xml
    - require:
      {% if 'cdh4.impala.server' in grains['roles'] %}
      - pkg: impala-server-install
      {% endif %}
      {% if 'cdh4.impala.state-store' in grains['roles'] %}
      - pkg: impala-state-store-install
      {% endif %}

/etc/impala/conf/core-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hadoop/conf/core-site.xml
    - require:
      {% if 'cdh4.impala.server' in grains['roles'] %}
      - pkg: impala-server-install
      {% endif %}
      {% if 'cdh4.impala.state-store' in grains['roles'] %}
      - pkg: impala-state-store-install
      {% endif %}

/etc/impala/conf/hdfs-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hadoop/conf/hdfs-site.xml
    - require:
      {% if 'cdh4.impala.server' in grains['roles'] %}
      - pkg: impala-server-install
      {% endif %}
      {% if 'cdh4.impala.state-store' in grains['roles'] %}
      - pkg: impala-state-store-install
      {% endif %}

{% if 'cdh4.hbase.master' in grains['roles'] or 'cdh4.hbase.regionserver' in grains['roles'] %}
/etc/impala/conf/hbase-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hbase/conf/hbase-site.xml
    - require:
      {% if 'cdh4.impala.server' in grains['roles'] %}
      - pkg: impala-server-install
      {% endif %}
      {% if 'cdh4.impala.state-store' in grains['roles'] %}
      - pkg: impala-state-store-install
      {% endif %}
{% endif %}
