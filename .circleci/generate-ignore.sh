#!/bin/sh

set -e

echo "locals {" > tests/01-default/ignore.tf
echo "  aws_account = \"${TF_VAR_aws_account}\"" >> tests/01-default/ignore.tf
echo "}" >> tests/01-default/ignore.tf

echo "locals {" > tests/02-provided-al2/ignore.tf
echo "  aws_account = \"${TF_VAR_aws_account}\"" >> tests/02-provided-al2/ignore.tf
echo "}" >> tests/02-provided-al2/ignore.tf
