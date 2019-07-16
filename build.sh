#! /bin/sh

mkdir releases
aws s3 cp "s3://ch-releases/sample-credhub-kms-plugin-0.0.5.tgz" releases/
tile build
