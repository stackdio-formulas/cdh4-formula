/etc/hadoop/conf:
  file:
    - recurse
    - source: salt://cdh4/etc/hadoop/conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
