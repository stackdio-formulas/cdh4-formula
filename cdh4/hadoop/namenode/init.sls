#
# Install namenode packages
#
# This formula requires an appropriate version of Java to also be installed.
# E.g. https://github.com/stackdio-formulas/java-formula
# 

include:
  - cdh4.repo
  - cdh4.hadoop.conf
  - cdh4.landing_page
{% if salt['pillar.get']('cdh4:namenode:start_service', True) %}
  - cdh4.hadoop.namenode.service
{% endif %}

extend:
  /etc/hadoop/conf:
    file:
      - require:
        - pkg: hadoop-hdfs-namenode
        - pkg: hadoop-0.20-mapreduce-jobtracker

##
# Installs the namenode package
#
# Must have a correct version of Java installed
##
hadoop-hdfs-namenode:
  pkg:
    - installed 
    - require:
      - module: cdh4_refresh_db

##
# Installs the hadoop job tracker service
#
# Must have a correct version of Java installed
##
hadoop-0.20-mapreduce-jobtracker:
  pkg:
    - installed
    - require:
      - module: cdh4_refresh_db

