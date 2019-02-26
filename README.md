# Building a Kubernetes Compatible Key Management Service Plugin Tile for Credhub in PCF

In order to use a Kubernetes Compatible Key Management Service Plugin with a CredHub bundled with PCF,
you will need to wrap your kms-plugin BOSH release in a
[tile](https://docs.pivotal.io/tiledev/2-4/index.html), which will be installed along side your PAS tile.

Instructions to build a Kubernetes Compatible KMS Plugin can be found [here](link to open source docs).

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

forms: # Unfortunately this is needed due to tile_generator behavior
- name: Fake
  label: Fake
  description: Fake

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
        include:
          jobs:
          - name: credhub
            release: credhub
```


To build the tile, simply run
```bash
tile build
```
from the directory you wrote `tile.yml` in.


