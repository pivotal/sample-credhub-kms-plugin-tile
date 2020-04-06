#!/bin/sh

set -ex

version="0.0.31"

smith om -- upload-product --product "product/sample-credhub-kms-plugin-tile-$version.pivotal"

smith om -- stage-product --product-name sample-credhub-kms-plugin-tile --product-version "$version"

cat <<EOF >/tmp/config.yml
---
product-name: sample-credhub-kms-plugin-tile
product-properties:
  .properties.socket_endpoint:
    value: /var/vcap/sys/run/credhub/sample-credhub-kms-plugin-tile.sock
EOF
smith om -- configure-product --config /tmp/config.yml

