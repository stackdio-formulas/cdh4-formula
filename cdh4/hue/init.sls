
# 
# Install the Hue package
#

include:
  - cdh4.repo
  - cdh4.landing_page
  - cdh4.hue.plugins
{% if salt['pillar.get']('cdh4:hue:start_service', True) %}
  - cdh4.hue.service
{% endif %}

hue:
  pkg:
    - installed
    - pkgs:
      - hue
      - hue-server
      - hue-plugins
    - require:
      - module: cdh4_refresh_db

/mnt/tmp/hadoop:
  file:
    - directory
    - makedirs: true
    - mode: 777

