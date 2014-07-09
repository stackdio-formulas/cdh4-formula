include:
  - cdh4.repo
  - cdh4.impala.conf
{% if salt['pillar.get']('cdh4:impala:start_service', True) %}
  - cdh4.impala.state-store.service
{% endif %}

impala-state-store-install:
  pkg:
    - installed
    - pkgs:
      - impala
      - impala-catalog
      - impala-state-store
      - impala-shell
    - require:
      - module: cdh4_refresh_db


