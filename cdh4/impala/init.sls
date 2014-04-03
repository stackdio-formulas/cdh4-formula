include:
  - cdh4.repo
{% if salt['pillar.get']('cdh4:impala:start_service', True) %}
  - cdh4.impala.service
{% endif %}

impala:
  pkg:
    - installed
    - pkgs:
      - impala
      - impala-server
      - impala-state-store
      - impala-shell
    - require:
      - module: cdh4_refresh_db


