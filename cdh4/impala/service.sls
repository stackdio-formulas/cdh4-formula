
{% if grains['os_family'] == 'Debian' %}
extend:
  remove_policy_file:
    file:
      - require:
        {% if 'cdh4.hadoop.namenode' in grains['roles'] %}
        - service: impala-state-store
        - service: impala-catalog
        {% endif %}
        {% if 'cdh4.hadoop.datanode' in grains['roles'] %}
        - service: impala-server
        {% endif %}
{% endif %}

# 
# Start impala processes
#

{% if 'cdh4.hadoop.namenode' in grains['roles'] %}
impala-state-store:
  service:
    - running
    - require:
      - pkg: impala
      - file: /etc/default/impala
      - file: /etc/default/bigtop-utils
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      - file: /etc/impala/conf/hbase-site.xml

impala-catalog:
  service:
    - running
    - require:
      - pkg: impala
      - service: impala-state-store
      - file: /etc/default/impala
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      - file: /etc/impala/conf/hbase-site.xml
{% endif %}

{% if 'cdh4.hadoop.datanode' in grains['roles'] %}
impala-server:
  service:
    - running
    - require:
      - pkg: impala
      - file: /etc/default/impala
      - file: /etc/default/bigtop-utils
      - file: /etc/impala/conf/hive-site.xml
      - file: /etc/impala/conf/core-site.xml
      - file: /etc/impala/conf/hdfs-site.xml
      - file: /etc/impala/conf/hbase-site.xml
{% endif %}
