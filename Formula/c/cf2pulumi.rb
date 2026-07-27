class Cf2pulumi < Formula
  desc "Convert CloudFormation Templates to Pulumi programs"
  homepage "https://github.com/pulumi/pulumi-aws-native"
  url "https://github.com/pulumi/pulumi-aws-native.git",
      tag:      "v1.73.1",
      revision: "d17c0673f93a3636c2a8400a6637ab15e6d560e6"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi-aws-native.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e1e04cb5a8d49febbc792e7c5118b183575f45b9b894dccafc63589ff71102dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e1e04cb5a8d49febbc792e7c5118b183575f45b9b894dccafc63589ff71102dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e04cb5a8d49febbc792e7c5118b183575f45b9b894dccafc63589ff71102dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f5a8cf82f6ad3498f88aa8c1e4ab48fd1eae7cbef4a0cc2491223e97e759058"
    sha256 cellar: :any,                 x86_64_linux:  "4c60a684843745e519d517ca9e0bf6d6f0209f25f5b189362d2860e6f3cc1737"
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
