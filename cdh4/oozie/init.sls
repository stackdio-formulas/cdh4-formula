{% set oozie_data_dir = '/var/lib/oozie' %}

# 
# Install the Oozie package
#

include:
  - cdh4.repo
  - cdh4.landing_page
{% if salt['pillar.get']('cdh4:oozie:start_service', True) %}
  - cdh4.oozie.service
{% endif %}

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

extjs:
  file:
    - managed
    - name: /srv/sync/cdh4/ext-2.2.zip
    - makedirs: true
    - source: http://extjs.com/deploy/ext-2.2.zip
    - source_hash: md5=12c624674b3af9d2ce218b1245a3388f
    - user: root
    - group: root
    - mode: 644
    - makedirs: true
    - require:
      - pkg: oozie
  cmd:
    - run
    - name: 'unzip -d {{ oozie_data_dir }} /srv/sync/cdh4/ext-2.2.zip &> /dev/null'
    - unless: 'test -d {{ oozie_data_dir }}/ext-*'
    - require:
      - file: /srv/sync/cdh4/ext-2.2.zip
      - pkg: unzip
      - pkg: oozie

/var/log/oozie:
  file:
    - directory
    - user: oozie
    - group: oozie
    - recurse:
      - user
      - group

/var/lib/oozie:
  file:
    - directory
    - user: oozie
    - group: oozie
    - recurse:
      - user
      - group

