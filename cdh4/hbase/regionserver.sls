include:
  - cdh4.repo
  - cdh4.landing_page
  - cdh4.hbase.conf

extend:
  /etc/hbase/conf/hbase-site.xml:
    file:
      - require:
        - pkg: hbase-regionserver
  /etc/hbase/conf/hbase-env.sh:
    file:
      - require:
        - pkg: hbase-regionserver
{% if grains['os_family'] == 'Debian' %}
  remove_policy_file:
    file:
      - require:
        - service: hbase-regionserver
{% endif %}

hbase-regionserver:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db
  service:
    - running
    - require: 
      - pkg: hbase-regionserver
      - file: /etc/hbase/conf/hbase-site.xml
      - file: /etc/hbase/conf/hbase-env.sh
    - watch:
      - file: /etc/hbase/conf/hbase-site.xml
      - file: /etc/hbase/conf/hbase-env.sh

