#{% from "vault/map.jinja" import vault with context %}

#include:
#  - .install
#  {%- if vault.verify_download %}
#  - .gpg
#  {%- endif %}

####################################################
# {% set platform_type = "linux_" + osarch %}
####################################################


ensure_libcap_is_installed:
  pkg.installed:
    - name: libcap

ensure_setcap_set_on_vault_binary:
  cmd.run:
    - name: setcap cap_ipc_lock=+ep /usr/local/bin/vault
    - require:
      - pkg: ensure_libcap_is_installed
    - onchanges:
      - archive: fetch_and_extract_vault_binary



salt 'vault01' slsutil.renderer salt://vault/files/vault.conf.j2 default_renderer='jinja'