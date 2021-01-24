# /srv/salt/orch/vault.sls
install_vault_lb_components:
  salt.state:
    - tgt: 'vaulthaproxy*'
    - sls:
      - load_balancer
      - load_balancer.configure

install_vault_components:
  salt.state:
    - tgt: 'vault0*'
    - sls:
      - vault.install
