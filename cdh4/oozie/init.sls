{% set oozie_data_dir = '/var/lib/oozie' %}
include:
  - cdh4.repo

unzip:
  pkg:
    - installed

oozie:
  pkg:
    - installed
    - pkgs:
      - oozie
      - oozie-client
    - require:
      - module: cdh4_refresh_db
  service:
    - running
    - require:
      - cmd: extjs
      - cmd: ooziedb
      - file: /var/log/oozie

extjs:
  file:
    - managed
    - name: /srv/sync/cdh4/ext-2.2.zip
    - source: http://extjs.com/deploy/ext-2.2.zip
    - source_hash: md5=12c624674b3af9d2ce218b1245a3388f
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: oozie
  cmd:
    - run
    - name: 'unzip -d {{ oozie_data_dir }} /srv/sync/cdh4/ext-2.2.zip &> /dev/null'
    - unless: 'test -d {{ oozie_data_dir }}/ext-*'
    - require:
      - file: /srv/sync/cdh4/ext-2.2.zip
      - pkg: unzip
      - pkg.installed: oozie

ooziedb:
  cmd:
    - run
    - name: '/usr/lib/oozie/bin/ooziedb.sh create -run'
    - unless: 'test -d {{ oozie_data_dir }}/oozie-db'
    - require:
      - pkg.installed: oozie

/var/log/oozie:
  file:
    - directory
    - user: oozie
    - group: oozie
    - recurse:
      - user
      - group
