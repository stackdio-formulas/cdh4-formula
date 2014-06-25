{% if salt['pillar.get']('cdh4:landing_page', True) %}
#
# Install thttpd
thttpd:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: thttpd
      - file: /var/www/thttpd/index.html

# Setup the landing page
/var/www/thttpd/index.html:
  file:
    - managed
    - source: salt://cdh4/landing_page/index.html
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - makedirs: true
    - require:
      - pkg: thttpd

{% endif %}
