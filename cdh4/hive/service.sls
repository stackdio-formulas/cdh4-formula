
# 
# Start the Hive service
#

include:
  - cdh4.repo

hive-svc:
  service:
    - running
    - name: hive
    - name: hive-metastore
    - require: 
      - pkg: hive

# @todo move this out to its own formula
mysql-svc:
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

