{% if pillar.get('cdh4.landing_page', True) %}
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
    - source: salt://cdh4/files/landing_page.html
    - user: root
    - group: root
    - mode: 755
    - template: jinja
    - require:
      - pkg: thttpd

{% endif %}
