include:
  - cdh4.repo

pig:
  pkg:
    - installed
    - pkgs:
      - pig
    - require:
      - module: cdh4_refresh_db

