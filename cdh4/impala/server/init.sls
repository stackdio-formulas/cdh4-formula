include:
  - cdh4.repo
  - cdh4.impala.conf
{% if salt['pillar.get']('cdh4:impala:start_service', True) %}
  - cdh4.impala.server.service
{% endif %}

impala-server-install:
  pkg:
    - installed
    - pkgs:
      - impala
      - impala-server
      - impala-shell
    - require:
      - module: cdh4_refresh_db


