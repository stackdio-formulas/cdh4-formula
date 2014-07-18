/mnt/hadoop/logs:
  file:
    - directory
    - mode: 777
    - makedirs: true

/etc/hadoop/conf:
  file:
    - recurse
    - source: salt://cdh4/etc/hadoop/conf
    - template: jinja
    - user: root
    - group: root
    - file_mode: 644

/etc/hadoop/conf/log4j.properties:
  file:
    - replace
    - pattern: 'maxbackupindex=20'
    - repl: 'maxbackupindex={{ pillar.cdh4.max_log_index }}'
    - require:
      {% if 'cdh4.hadoop.namenode' in grains['roles'] %}
      - pkg: hadoop-hdfs-namenode
      {% endif %}
      {% if 'cdh4.hadoop.datanode' in grains['roles'] %}
      - pkg: hadoop-hdfs-datanode
      {% endif %}

