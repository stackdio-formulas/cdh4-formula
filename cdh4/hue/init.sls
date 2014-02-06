include:
  - cdh4.repo
  - cdh4.landing_page

hue:
  pkg:
    - installed
    - pkgs:
      - hue
      - hue-server
      - hue-plugins
    - require:
      - module: cdh4_refresh_db
  service:
    - running
    - require:
      - file: /mnt/tmp/hadoop
      - file: /etc/hue/hue.ini

/mnt/tmp/hadoop:
  file:
    - directory
    - makedirs: true
    - mode: 777

/etc/hue/hue.ini:
  file:
    - managed
    - template: jinja
    - source: salt://cdh4/etc/hue/hue.ini
    - mode: 755
