include:
  - cdh4.repo

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


