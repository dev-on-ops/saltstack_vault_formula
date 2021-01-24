template_configuration_file:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/etc/keepalived/keepalived.conf.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: template_configuration_file

haproxy_running:
  service.running:
    - name: keepalived
    - watch:
      - module: template_configuration_file