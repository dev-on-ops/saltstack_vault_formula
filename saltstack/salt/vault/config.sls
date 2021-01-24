# checks if the install section of the vault pillar is set and configures prefix for downloads
{% if pillar.vault.install is defined %}
  {% set vault = salt['pillar.get']('vault') %}
  {% set osarch = grains.osarch %}
  {% set vault_version = vault.install.version %}
  {% if grains.os_family == 'RedHat' %}
    {% set platform_type = "linux" %}
  {% elif grains.os_family == 'Debian' %}
    {% set platform_type = "linux" %}
  {% elif grains.os_family == 'Windows' %}
    {% set platform_type = "windows" %}
  {% endif %}
# checks if the system should have enterprise
  {% if vault.install.enterprise == True %}
    {% set vault_zip = "vault_" + vault_version + "+ent" + "_" + platform_type + "_" + osarch + ".zip" %}
    {% set vault_shasums = "vault_" + vault_version + "+ent" + "_" + "SHA256SUMS" %}
  {% else %}
    {% set vault_zip = "vault_" + vault_version + "_" + platform_type + "_" + osarch + ".zip" %}
    {% set vault_shasums = "vault_" + vault_version + "_" + "SHA256SUMS" %}
  {% endif %}
# Configure Vault user and group
ensure-vault-group-exists:
  group.present:
    - name: vault
    - system: True


#test_task:
#  cmd.run:
#    - name: echo {{ vault_version }}
