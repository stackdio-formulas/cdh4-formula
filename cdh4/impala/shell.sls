#
# Install the impala shell
#
include:
  - cdh4.repo

impala-shell:
  pkg:
    - installed
    - require:
      - module: cdh4_refresh_db
