class Cf2pulumi < Formula
  desc "Convert CloudFormation Templates to Pulumi programs"
  homepage "https://github.com/pulumi/pulumi-aws-native"
  url "https://github.com/pulumi/pulumi-aws-native.git",
      tag:      "v1.82.0",
      revision: "46d819b848f8c912cbbb0f0fab26722d2a72e3fd"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi-aws-native.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "275d3d8dee35f92c28f192e0b5965374e3985b00d33879556986d0943ffc9f8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7fc0d2bc3187605bdbbb8a4aa5b8fb8fbebbaeae5b36e2b15c381b4fb0760ec8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86acca2ef8ef81703dc6343c17309c7837648525d5b0c8d7034778620ef6d95b"
    sha256 cellar: :any,                 x86_64_linux:  "bbb314676fb3de9f17a31f20775b16df5b1953407feb2003edd882b77dcc39b4"
  end

  depends_on "go" => :build
  depends_on "pulumictl" => :build

  resource "cloudformation-documentation" do
    url "https://github.com/cdklabs/awscdk-service-spec/raw/686af4fbc690a9d08c07a862941bb6d1810e330f/sources/CloudFormationDocumentation/CloudFormationDocumentation.json"
    sha256 "623bc4f5a823f07e223786d8d95e029a95b8e69c96c6b8a08fb61422b7e8d98d"
  end

  deny_network_access!

  def fetch
    cd "provider" do
      system "go", "mod", "download"
    end
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/pulumi/pulumi-aws-native/provider/version.Version=#{version}
    ]
    cd "provider" do
      system "go", "build",
            *std_go_args(ldflags:, output: buildpath/"bin/pulumi-gen-aws-native"),
            "./cmd/pulumi-gen-aws-native"
    end

    resource("cloudformation-documentation").stage do
      (buildpath/"aws-cloudformation-docs").install "CloudFormationDocumentation.json"
    end
    system buildpath/"bin/pulumi-gen-aws-native",
           "--schema-folder", "aws-cloudformation-schema",
           "--version", version.to_s,
           "--metadata-folder", "meta",
           "schema"
    cd "provider" do
      system "go", "build", *std_go_args(ldflags:), "./cmd/cf2pulumi"
    end
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      AWSTemplateFormatVersion: '2010-09-09'
      Resources:
        MyS3Bucket:
          Type: 'AWS::S3::Bucket'
          Properties:
            BucketName: my-test-bucket
            AccessControl: Private
        MyEC2Instance:
          Type: 'AWS::EC2::Instance'
          Properties:
            InstanceType: t2.micro
            ImageId: ami-0c55b159cbfafe1f0
    YAML

    assert_match <<~TYPESCRIPT, shell_output("#{bin}/cf2pulumi nodejs #{testpath}/test.yaml")
      import * as pulumi from "@pulumi/pulumi";
      import * as aws_native from "@pulumi/aws-native";

      const myS3Bucket = new aws_native.s3.Bucket("myS3Bucket", {
          bucketName: "my-test-bucket",
          accessControl: aws_native.s3.BucketAccessControl.Private,
      });
      const myEC2Instance = new aws_native.ec2.Instance("myEC2Instance", {
          instanceType: "t2.micro",
          imageId: "ami-0c55b159cbfafe1f0",
      });
    TYPESCRIPT

    assert_match <<~PYTHON, shell_output("#{bin}/cf2pulumi python #{testpath}/test.yaml")
      import pulumi_aws_native as aws_native

      my_s3_bucket = aws_native.s3.Bucket("myS3Bucket",
          bucket_name="my-test-bucket",
          access_control=aws_native.s3.BucketAccessControl.PRIVATE)
      my_ec2_instance = aws_native.ec2.Instance("myEC2Instance",
          instance_type="t2.micro",
          image_id="ami-0c55b159cbfafe1f0")
    PYTHON
  end
end
