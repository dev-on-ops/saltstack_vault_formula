{% if pillar.vault is defined %}
include:
  - vault.install
  - vault.config
#  - vault.initialize
#  - vault.license
{%endif%}
