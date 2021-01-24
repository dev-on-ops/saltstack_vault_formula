keepalived_hosts:
{% if grains['nodename'] ==  'haproxy01' %}
    vip_role: MASTER
    vip_ip: 192.168.255.20
    vip_interface: eth1
    vrrp_id: 50
    vrrp_priority: 100
{% elif grains['nodename'] == 'haproxy02' %}
    vip_role: BACKUP
    vip_ip: 192.168.255.20
    vip_interface: eth1
    vrrp_id: 50
    vrrp_priority: 99
{% endif %}

haproxy_components:
  - 
{% if grains['nodename'] ==  'haproxy01' %}
    vip_role: MASTER
    vip_ip: 192.168.255.20
    vip_interface: eth1
    vrrp_id: 50
    vrrp_priority: 100
{% elif grains['nodename'] == 'haproxy02' %}
    vip_role: BACKUP
    vip_ip: 192.168.255.20
    vip_interface: eth1
    vrrp_id: 50
    vrrp_priority: 99
{% endif %}