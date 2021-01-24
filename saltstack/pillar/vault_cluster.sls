vault:
  install:
    type: repo
    enterprise: false
    version: 1.6.0
  config:
    ui: true
    seal:
#######################
# shamier options below
#      type: shamir
#######################
# transit options below
#      type: transit
#      address: test
#      token: kdjfkjdfkjd
#      disable_renewal: false
#      key_name: dkjfksdjf
#      mount_path: transit/
#      namespace: test
#      tls_ca_cert: kdjfjd
#      tls_client_cert: jj
#      tls_client_key: aa
#      tls_server_name: test
#      tls_skip_verify: false
#######################
      type: aws_kms
      kms_key_id: djfdsfds
      access_key: kdsjfkjs
      secret_key: kdjfssdf
      region: us-west-1
      session_token: jdfkjd
      endpoint: http://sdfd.abc
      