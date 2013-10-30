include:
  - cdh4.repo
  - cdh4.landing_page
  - cdh4.hbase.conf

extend:
  /etc/hbase/conf/hbase-site.xml:
    file:
      - require:
        - pkg: hbase-regionserver

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
    - watch:
      - file: /etc/hbase/conf/hbase-site.xml

