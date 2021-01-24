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

ensure-vault-user-exists:
  user.present:
    - name: vault
    - gid: vault
    - require:
      - group: ensure-vault-group-exists
# fetch vault files
# if statement should exist here for the different install types like salt or url
# should include gpg verification of signature of files here also
fetch_shasums_for_vault_binary:
  file.managed:
    - name: /usr/local/bin/{{ vault_shasums }}
    - source: https://releases.hashicorp.com/vault/{{ vault_version }}/{{ vault_shasums }}
    - skip_verify: True

fetch_and_extract_vault_binary:
  archive.extracted:
    - name: /usr/local/bin
    - source: https://releases.hashicorp.com/vault/{{ vault_version }}/{{ vault_zip }}
    - source_hash: https://releases.hashicorp.com/vault/{{ vault_version }}/{{ vault_shasums }}
    - source_hash_name: {{ vault_zip }}
    - enforce_toplevel: False
    - overwrite: True
    - onchanges:
      - file: fetch_shasums_for_vault_binary

# Set capabilites on vault file
ensure_libcap_is_installed:
  pkg.installed:
    - name: libcap2-bin

ensure_setcap_set_on_vault_binary:
  cmd.run:
    - name: setcap cap_ipc_lock=+ep /usr/local/bin/vault
    - require:
      - pkg: ensure_libcap_is_installed

{% endif %}