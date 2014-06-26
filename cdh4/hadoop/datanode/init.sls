
# This formula requires an appropriate version of Java to also be installed.
# E.g. https://github.com/stackdio-formulas/java-formula
#
include:
  - cdh4.repo
  - cdh4.hadoop.conf
  - cdh4.landing_page
  - cdh4.hadoop.client
{% if salt['pillar.get']('cdh4:datanode:start_service', True) %}
  - cdh4.hadoop.datanode.service
{% endif %}

extend:
  /etc/hadoop/conf:
    file:
      - require:
        - pkg: hadoop-hdfs-datanode
        - pkg: hadoop-0.20-mapreduce-tasktracker

##
# Installs the datanode service
#
# Must have a correct version of Java installed
##
hadoop-hdfs-datanode:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db

##
# Installs the task tracker service
#
# Must have a correct version of Java installed
##
hadoop-0.20-mapreduce-tasktracker:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db

