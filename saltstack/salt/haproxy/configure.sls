template_configuration_file:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/files/etc/haproxy/haproxy.cfg.jinja
    - template: jinja
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: template_configuration_file

haproxy_running:
  service.running:
    - name: haproxy
    - watch:
      - module: template_configuration_file