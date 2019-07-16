# Building a Kubernetes Compatible Key Management Service Plugin Tile for Credhub in PCF

In order to use a Kubernetes Compatible Key Management Service Plugin with a CredHub bundled with PCF,
you will need to wrap your kms-plugin BOSH release in a
[tile](https://docs.pivotal.io/tiledev/2-4/index.html), which will be installed along side your PAS tile.

Instructions to build a Kubernetes Compatible KMS Plugin can be found [here](https://docs.cloudfoundry.org/credhub/kms-plugin.html).

You will need to install your release as a [runtime config](https://bosh.io/docs/runtime-config/),
which is a BOSH job that will be installed on every instance group that matches the information
specified in the [include](https://bosh.io/docs/runtime-config/#placement-rules) block.

## Dependencies

- To build the tile we will use [tile_generator](https://docs.pivotal.io/tiledev/2-4/tile-generator.html).

- Install with:
```bash
virtualenv -p python2 tile-generator-env
source tile-generator-env/bin/activate
pip install tile-generator
```

## Make the tile

To use tile generator, you need a `tile.yml`, which contains configuration information, as well as the actual BOSH release you want to install. 

You can allow an operator to configure arbitrary properties in your manifest using [custom forms and properties](https://docs.pivotal.io/tiledev/2-4/tile-generator.html#custom-forms),
here we allow the operator to configure the socket endpoint for the plugin to listen to CredHub on.

Here is an example `tile.yml`

```yaml
---
name: sample-credhub-kms-plugin-tile
icon_file: icon.png
label: Sample CredHub KMS Plugin
description: Sample CredHub KMS Plugin

packages:
- name: my-release-name
  type: bosh-release
  path: releases/<my-release>.tgz

forms:
- name: plugin-properties
  label: Plugin Properties
  description: Configure your plugin
  properties:
  - name: socket_endpoint
    type: string
    label: Socket Endpoint

runtime_configs:
- name: some-runtime-config
  runtime_config:
    releases:
    - name: my-release-name
      version: "my-release-version"
    addons:
    - name: some-addon-name
      jobs:
      - name: my-job-name
        release: my-release-name
        properties:
          kms-plugin:
            socket_endpoint: (( .properties.socket_endpoint.value ))
            certificate: ((( provider-certificate.certificate )))
            private_key: ((( provider-certificate.private_key )))
      include:
        jobs:
        - name: credhub
          release: credhub

variables:
- name: provider-certificate
  type: certificate
  options:
    ca: /services/tls_ca
    common_name: credhub-kms
```


Note: The ca and hostname in the `provider-certificate` variable must be exactly
the same as the example above as these are the only values the PAS tile will accept.

To build the tile, simply run
```bash
tile build
```
from the directory you wrote `tile.yml` in.

## Install the tile

- Upload the product to an Opsmanager.

- Configure the tile.

- Click apply changes.


