class Cf2pulumi < Formula
  desc "Convert CloudFormation Templates to Pulumi programs"
  homepage "https://github.com/pulumi/pulumi-aws-native"
  url "https://github.com/pulumi/pulumi-aws-native.git",
      tag:      "v1.63.0",
      revision: "b5eb36345fcff976f05eeab180196db61db4fe31"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi-aws-native.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "859d56a2ce8ff6c8511c4dadf2ae763ebe4c35ebfa324b73083bb5c60c297f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "859d56a2ce8ff6c8511c4dadf2ae763ebe4c35ebfa324b73083bb5c60c297f67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "859d56a2ce8ff6c8511c4dadf2ae763ebe4c35ebfa324b73083bb5c60c297f67"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "32cf2d4255d30d363bd515680abd20db07fce4e22feb235fb7d13df55e1f29e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbd75b4cca5c8098622a362ca36384c5cf4bd1d75442f2afc49581797385e837"
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
