#!/bin/sh

set -e

echo "  aws_account = \"${TF_VAR_aws_account}\"" > tests/01-ignore.tfvars
echo "  hosted_zone_id = \"${TF_VAR_hosted_zone_id}\"" >> tests/01-ignore.tfvars
