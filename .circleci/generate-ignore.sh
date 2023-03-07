#!/bin/sh

set -e

echo "locals {" > tests/default/ignore.tf
echo "  aws_account = \"${TF_VAR_aws_account}\"" >> tests/default/ignore.tf
echo "}" >> tests/default/ignore.tf
