include:
  - cdh4.repo

hive:
  pkg:
    - installed
    - pkgs:
      - hive
      - hive-metastore
      - hive-server2
    - require:
      - pkg: mysql
      - module: cdh4_refresh_db
  service:
    - running
    - name: hive-metastore
    - require: 
      - pkg: hive

# @todo move this out to its own formula
mysql:
  pkg:
    - installed
    - pkgs:
      - mysql-server
      - mysql-connector-java
  service:
    - running
    - name: mysqld

configure_metastore:
  cmd:
    - script
    - template: jinja
    - source: salt://cdh4/hive/configure_metastore.sh
    - unless: echo "show databases" | mysql -u root | grep metastore
    - require: 
      - pkg: hive

hive-metastore:
  service:
    - running
    - require: 
      - cmd: configure_metastore

/usr/lib/hive/lib/mysql-connector-java.jar:
  file:
    - symlink
    - target: /usr/share/java/mysql-connector-java.jar
    - require: 
      - pkg: mysql

/etc/hive/conf/hive-site.xml:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hive/hive-site.xml

