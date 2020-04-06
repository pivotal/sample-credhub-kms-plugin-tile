#! /bin/sh

mkdir releases
gsutil cp "gs://ch-releases/sample-credhub-kms-plugin-0.0.5.tgz" releases/
tile build
