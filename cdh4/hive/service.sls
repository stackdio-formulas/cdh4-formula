
# 
# Start the Hive service
#

include:
  - cdh4.repo

{% if grains['os_family'] == 'Debian' %}
extend:
  remove_policy_file:
    file:
      - require:
        - service: hive-metastore
        - service: hive-server2
        - service: mysql-svc
{% endif %}

# @todo move this out to its own formula
mysql-svc:
  service:
    - running
    {% if grains['os_family'] == 'Debian' %}
    - name: mysql
    {% elif grains['os_family'] == 'RedHat' %}
    - name: mysqld
    {% endif %}
    - require:
      - pkg: mysql

configure_metastore:
  cmd:
    - script
    - template: jinja
    - source: salt://cdh4/hive/configure_metastore.sh
    - unless: echo "show databases" | mysql -u root | grep metastore
    - require: 
      - pkg: hive
      - service: mysql-svc

hive-metastore:
  service:
    - running
    - require: 
      - pkg: hive
      - cmd: configure_metastore
      - service: mysql-svc
      - file: /usr/lib/hive/lib/mysql-connector-java.jar
      - file: /etc/hive/conf/hive-site.xml
      - file: /mnt/tmp/

hive-server2:
  service:
    - running
    - require: 
      - service: hive-metastore

/mnt/tmp/:
  file:
    - directory
    - user: root
    - group: root
    - dir_mode: 777

