{% set dfs_name_dir = salt['pillar.get']('cdh4:dfs:name_dir', '/mnt/hadoop/hdfs/nn') %}
{% set mapred_local_dir = salt['pillar.get']('cdh4:mapred:local_dir', '/mnt/hadoop/mapred/local') %}
{% set mapred_system_dir = salt['pillar.get']('cdh4:mapred:system_dir', '/hadoop/system/mapred') %}
{% set mapred_staging_dir = '/var/lib/hadoop-hdfs/cache/mapred/mapred/staging' %}

#
# Configure and start all namenode services
# 

##
# Starts the namenode process
#
# Must have a correct version of Java installed
##
hadoop-hdfs-namenode-svc:
  service:
    - running
    - name: hadoop-hdfs-namenode
    - require: 
      - pkg: hadoop-hdfs-namenode
      # Make sure HDFS is initialized before the namenode
      # is started
      - cmd: init_hdfs
      - file: /etc/hadoop/conf
    - watch:
      - file: /etc/hadoop/conf

##
# Starts the hadoop job tracker service
#
# Must have a correct version of Java installed
##
hadoop-0.20-mapreduce-jobtracker-svc:
  service:
    - running
    - name: hadoop-0.20-mapreduce-jobtracker
    - require: 
      - pkg: hadoop-0.20-mapreduce-jobtracker
      - cmd: namenode_mapred_local_dirs
      - cmd: mapred_system_dirs
      - cmd: hdfs_mapreduce_var_dir
      - file: /etc/hadoop/conf
    - watch:
      - file: /etc/hadoop/conf

# Make sure the namenode metadata directory exists
# and is owned by the hdfs user
cdh4_dfs_dirs:
  cmd:
    - run
    - name: 'mkdir -p {{ dfs_name_dir }} && chown -R hdfs:hdfs `dirname {{ dfs_name_dir }}`'
    - unless: 'test -d {{ dfs_name_dir }}'
    - require:
      - pkg: hadoop-hdfs-namenode
      - file: /etc/hadoop/conf

# Initialize HDFS. This should only run once, immediately
# following an install of hadoop.
init_hdfs:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hdfs namenode -format'
    - unless: 'test -d {{ dfs_name_dir }}/current'
    - require:
      - cmd: cdh4_dfs_dirs

# HDFS tmp directory
hdfs_tmp_dir:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hadoop fs -mkdir /tmp && hadoop fs -chmod -R 1777 /tmp'
    - unless: 'hadoop fs -test -d /tmp'
    - require:
      - service: hadoop-hdfs-namenode

# HDFS MapReduce var directories
hdfs_mapreduce_var_dir:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hadoop fs -mkdir -p {{ mapred_staging_dir }} && hadoop fs -chmod 1777 {{ mapred_staging_dir }} && hadoop fs -chown -R mapred `dirname {{ mapred_staging_dir }}`'
    - unless: 'hadoop fs -test -d {{ mapred_staging_dir }}'
    - require:
      - service: hadoop-hdfs-namenode

# MR local directory
namenode_mapred_local_dirs:
  cmd:
    - run
    - name: 'mkdir -p {{ mapred_local_dir }} && chown -R mapred:hadoop {{ mapred_local_dir }}'
    - unless: 'test -d {{ mapred_local_dir }}'
    - require:
      - pkg: hadoop-hdfs-namenode
      - pkg: hadoop-0.20-mapreduce-jobtracker

# MR system directory
mapred_system_dirs:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hadoop fs -mkdir {{ mapred_system_dir }} && hadoop fs -chown mapred:hadoop {{ mapred_system_dir }}'
    - unless: 'hadoop fs -test -d {{ mapred_system_dir }}'
    - require:
      - service: hadoop-hdfs-namenode

# set permissions at the root level of HDFS so any user can write to it
hdfs_permissions:
  cmd:
    - run
    - user: hdfs
    - group: hdfs
    - name: 'hadoop fs -chmod 777 / && hadoop fs -mkdir -p /user/{{pillar.__stackdio__.username}}/ && hadoop fs -chown {{pillar.__stackdio__.username}}:{{pillar.__stackdio__.username}} /user/{{pillar.__stackdio__.username}}'
    - require:
      - service: hadoop-0.20-mapreduce-jobtracker



