
#
# Install the HBase regionserver package
#

include:
  - cdh4.repo
  - cdh4.landing_page
  - cdh4.hbase.conf
{% if salt['pillar.get']('cdh4:hbase:start_service', True) %}
  - cdh4.hbase.regionserver.service
{% endif %}

extend:
  /etc/hbase/conf/hbase-site.xml:
    file:
      - require:
        - pkg: hbase-regionserver
  /etc/hbase/conf/hbase-env.sh:
    file:
      - require:
        - pkg: hbase-regionserver

hbase-regionserver:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db

