# Write all regionserver hosts to /etc/hosts
append_regionservers_etc_hosts:
  file:
    - append
    - name: /etc/hosts
    - text: 
{% for host, items in salt['publish.publish']('G@stack_id:' ~ grains.stack_id ~ ' and G@roles:cdh4.hbase.regionserver', 'grains.items', '', 'compund').items() %}
      - "{{ items['ip_interfaces']['eth0'][0] }} {{ items['fqdn'] }}"
{% endfor %}
