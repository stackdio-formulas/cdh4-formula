/etc/hbase/conf/hbase-site.xml:
  file:
    - managed
    - source: salt://cdh4/etc/hbase/conf/hbase-site.xml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - makedirs: true

/etc/hbase/conf/hbase-env.sh:
  file:
    - managed
    - source: salt://cdh4/etc/hbase/conf/hbase-env.sh
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - makedirs: true

{{ pillar.cdh4.hbase.tmp_dir }}:
  file.directory:
    - user: hbase
    - group: hbase
    - dir_mode: 755
    - makedirs: true

{{ pillar.cdh4.hbase.log_dir }}:
  file.directory:
    - user: hbase
    - group: hbase
    - dir_mode: 755
    - makedirs: true

/etc/hbase/conf/log4j.properties:
  file:
    - replace
    - pattern: 'maxbackupindex=20'
    - repl: 'maxbackupindex={{ pillar.cdh4.max_log_index }}'
    - require:
      {% if 'cdh4.hbase.master' in grains['roles'] %}
      - pkg: hbase-master
      {% endif %}
      {% if 'cdh4.hbase.regionserver' in grains['roles'] %}
      - pkg: hbase-regionserver
      {% endif %}

