# Write all regionserver hosts to /etc/hosts
{% set regionservers = salt['publish.publish']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh4.hbase.regionserver', 'grains.get', 'ip_interfaces:eth0', 'compound').items() %}
{% if regionservers %}
append_regionservers_etc_hosts:
  file:
    - append
    - name: /etc/hosts
{% for host, ip in regionservers %}
    - text: {{ ip[0] }} {{ host }}
{% endfor %}
{% endif %}
