{% set mapred_local_dir = salt['pillar.get']('cdh4:mapred:local_dir', '/mnt/hadoop/mapred/local') %}
{% set dfs_data_dir = salt['pillar.get']('cdh4:dfs:data_dir', '/mnt/hadoop/hdfs/data') %}

#
# Start the datanode services
# 

##
# Starts the datanode service
#
##
hadoop-hdfs-datanode-svc:
  service:
    - running
    - name: hadoop-hdfs-datanode
    - require: 
      - pkg: hadoop-hdfs-datanode
      - cmd: dfs_data_dir
      - file: /etc/hadoop/conf
    - watch:
      - file: /etc/hadoop/conf

##
# Starts the task tracker service
##
hadoop-0.20-mapreduce-tasktracker-svc:
  service:
    - running
    - name: hadoop-0.20-mapreduce-tasktracker
    - require: 
      - pkg: hadoop-0.20-mapreduce-tasktracker
      - cmd: datanode_mapred_local_dirs
      - file: /etc/hadoop/conf
    - watch:
      - file: /etc/hadoop/conf

# make the local storage directories
datanode_mapred_local_dirs:
  cmd:
    - run
    - name: 'mkdir -p {{ mapred_local_dir }} && chmod -R 755 {{ mapred_local_dir }} && chown -R mapred:mapred {{ mapred_local_dir }}'
    - unless: "test -d {{ mapred_local_dir }} && [ `stat -c '%U' {{ mapred_local_dir }}` == 'mapred' ]"
    - require:
      - pkg: hadoop-0.20-mapreduce-tasktracker

# make the hdfs data directories
dfs_data_dir:
  cmd:
    - run
    - name: 'for dd in `echo {{ dfs_data_dir }} | sed "s/,/\n/g"`; do mkdir -p $dd && chmod -R 755 $dd && chown -R hdfs:hdfs $dd; done'
    - unless: "test -d `echo {{ dfs_data_dir }} | awk -F, '{print $1}'` && [ $(stat -c '%U' $(echo {{ dfs_data_dir }} | awk -F, '{print $1}')) == 'hdfs' ]"
    - require:
      - pkg: hadoop-hdfs-datanode

