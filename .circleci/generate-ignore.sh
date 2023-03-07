#!/bin/sh

set -e

echo << 'EOF'
locals {
  aws_account = "${TF_VAR_aws_account}"
}
EOF > tests/default/ignore.tf
