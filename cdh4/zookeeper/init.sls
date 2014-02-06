include:
  - cdh4.repo

zookeeper:
  pkg:
    - installed
    - require:
      - module: cdh4_refresh_db

/etc/zookeeper/conf/zoo.cfg:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/zookeeper/conf/zoo.cfg
    - mode: 755
    - require: 
      - pkg: zookeeper

zookeeper-server:
  pkg:
    - installed
    - require:
      - pkg: zookeeper
  service:
    - running
    - unless: service zookeeper-server status
    - require:
      - file: myid

myid:
  file:
    - managed
    - name: '{{pillar.cdh4.zookeeper.data_dir}}/myid'
    - template: jinja
    - user: zookeeper
    - group: zookeeper
    - mode: 755
    - source: salt://cdh4/etc/zookeeper/conf/myid
    - require:
        - cmd: zookeeper-init

zookeeper-init:
  cmd:
    - run
    - name: 'service zookeeper-server init'
    - unless: 'ls {{pillar.cdh4.zookeeper.data_dir}}/*'
    - require:
      - pkg: zookeeper-server
