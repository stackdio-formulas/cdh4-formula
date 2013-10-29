include:
  - cdh4.repo
  - cdh4.landing_page
  - cdh4.hbase.conf

hbase-regionserver:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db
  service:
    - running
    - require: 
      - pkg: hbase-regionserver
      - file: regionserver_hbase_site
    - watch:
      - file: regionserver_hbase_site

regionserver_hbase_site:
  file:
    - managed
    - name: /etc/hbase/conf/hbase-site.xml
    - source: salt://cdh4/etc/hbase/conf/hbase-site.xml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: hbase-regionserver
