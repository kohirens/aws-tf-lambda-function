This test requires that the Go executable be built with this method:
[Migrating AWS Lambda functions from the Go1.x runtime to the custom runtime on Amazon Linux 2]

Windows:

```shell
cd tests/testdata/bootstrap
$Env:GOARCH="arm64"; $Env:GOOS="linux" ; go build -tags lambda.norpc
```

Linux

```shell
cd tests/testdata/bootstrap
GOARCH="arm64" GOOS="linux" go build -tags lambda.norpc
```
---

[Migrating AWS Lambda functions from the Go1.x runtime to the custom runtime on Amazon Linux 2]: https://aws.amazon.com/blogs/compute/migrating-aws-lambda-functions-from-the-go1-x-runtime-to-the-custom-runtime-on-amazon-linux-2/#Removing%20the%20RPC%20dependency