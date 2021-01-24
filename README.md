# Vault Salt State

Intent of this state is to provide options for automated deployment of hashicorp vault on linux platforms. It maybe extended to windows at a later date and time. Options in this context means you can choose to include up to different stages of automation depending on security requirements. See notes below on stages available:
Maybe adjusted at a later date to account for overal environments rather then single clusters.

# Stages
0. init.sls: includes all needed states in order to complete installation of needed pillar is configured on host state is applied to
1. install.sls: installs vault binary and requires the below variables set in the vault stanza
* install.type: options are repo, salt, url
- repo pulls from the hashicorp public repo for fetching files
- salt pulls from the files directory under the vault state
- url pulls from the web address provided in install_url
* install.binary_type: options are enterprise or oss, used to determine which install to pull and further deployment specific configurations
* install.url: only used with install_location_type variable and forces retrieving form http/https location
* install.version: version to install from the install location
2. config.sls: configures the vault system as a vault server with a service configuration and appropiate configuration to start the vault server
* storage.type: options are intergrated_raft at this time, consul maybe supported at a later date and time.
* storage.path: file path for raft storage and other related files to be configured
* unseal.type: options are shamir, transit, aws_kms at this time. Additional cloud providers maybe tested and validated at a later date and time.
* unseal.transit.key: name of transit key for transit unseal type
* unseal.transit.token: token used for tranist unseal authenticaiton
* unseal.transit.address: address of unseal cluster
* unseal.aws_kms.key_id: key id of aws kms key
* unseal.aws_iam.access_id: access key id for using kms service
* unseal.aws_iam.secret_id: secret key for iam access id for using kms service
* unseal.aws_kms.region: region name of the kms key resides in 
* cluster.hosts: list of fully qualified domain names of vault servers in the cluster.
* cluster.leader: fully qualified domain name of the vault server to perform initialization of the cluster.
* tls.enabled: options are true or false.
- true: configures the system to use tls certificates for listener interfaces and client interfaces
- false: configures the system to use http traffic only for listener interfaces and client interfaces
* web_ui.enabled: options are true or false
- true: web interface is enabled and accessible
- false: web interface is disabled and not accessible, api is still accessible
3. initialize.sls:
* unseal_and_recovery.key_protection: options are pgp, keybase, none
- pgp, list of keys provide will encrypt the shamir recovery or unseal keys in order of list and keys must be in base 64 format in list. See vault documentation on exporting in correct format. copy of keys will be stored on disk.
- keybase, will use keybase names in list to gather keys and encrypt the recovery or unseal keys, copy of keys will be stored on disk.
- none, keys will not be encrypted and will be stored on disk
* unseal_and_recovery.key_shards: interger, number of key shards to generate for recovery or unseal
* unseal_and_recovery.key_threshold: interger, number less then or equal to shards for total needed keys to perform unseal  or recovery operations
* unseal_and_recovery.key_protection_keys: list of base64 encoded pgp public keys or keybase names
* token_handling.root_token_protection: pgp, none
- pgp, copy stored on disk, must provided base 64 encoded pgp public key
- none, copy stored on disk, used for testing purposes only
* token_handling.root_token_protection_key: base 64 string of pgp key, keybase name or none
4. license.sls:
* license_value: license file contents without new line characters
5. admin_policy.sls:
* to be determined

## Additional States
1. snapshot_save.sls:
* to be determined
2. snapshot_restore.sls:
* to be determined
3. version_upgrade.sls:
* to be determined

~~~
#Example pillar
vault:
  install:
    location_type: repo
    type: oss
    version: 1.6.0
  config:
    storage:
      type: raft
      path: /data
    unseal:
      type: aws_kms
#      transit:
#        address: https://transit-cluster.fqdn
#        key: mc.xnvlsdnfleihrernlnsd
#        token: cnv,mnxz,nvzmxcvzcvndj
      aws_kms_key_id: kjdflakjdlfkjaldskjfalkjdsf
      aws_iam_access_id: kjadlskfjaldksjflajdsfal
      aws_iam_secret_id: kajdlfjalkdjfa;lkdfjlkadfj
      aws_kms_region: us west 1
    cluster:
      hosts:
        - fqdn01
        - fqdn02
      leader: fqdn01
    tls
      enabled: true
    web_ui
      enabled: true
  init:
    unseal_and_recovery:
      key_protection: pgp
      key_shards: 3
      key_threshold: 2
      key_protection_keys:
        - lkdsjflakjsdlfkjalkjdflkjaldfjaljdsf;la;flda
        - lakjdfljkaldjflakjdsflkjadsfjasdfdkjfjdfkjds
        - jaldkjflakjdsflkjaldskjflakjdsflkjalsdjflajf
    token_handling:
      root_token_protection: pgp
      root_token_protection_key: kjflakjds;lfkjaldkjsflkajdsfljadsf;lkja;ldksfjalkjdsf
  license:
    license_value: ksdjflakjsdflkjaldsfjlajdflsjaljflkajsdfljaldsfa
~~~

Notes:
State is intended to be convergent but not deploy random clusters. Pillar configurations are required for deployment to be succesful. Orchestrations are not required for a complete cluster to be deployed. Version upgrades to be handled at later date.
