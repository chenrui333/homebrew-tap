class Cf2pulumi < Formula
  desc "Convert CloudFormation Templates to Pulumi programs"
  homepage "https://github.com/pulumi/pulumi-aws-native"
  url "https://github.com/pulumi/pulumi-aws-native.git",
      tag:      "v1.34.0",
      revision: "30d99bb5e3f62bb28007c5cfccc4686b963b885b"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi-aws-native.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3877ebbb498258d5ec1d2ad3d0a8b4dca6e08481285681fa5a186b5fc63c2621"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c827d4281ba251941cad4812e09b7af2c794a0c58ce688d712868bd91a9c23"
    sha256 cellar: :any_skip_relocation, ventura:       "6e0b124ac15210edca57bd9887e86305cabb45d8d60cf987a9730c53b2f25e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "164c37b2eb017e34060c8f726e3d118944635a470b050fe27c82d2ccc7523edf"
  end

  depends_on "go" => :build
  depends_on "pulumictl" => :build

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

    system "make", "generate_schema"
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
