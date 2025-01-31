class Cfnctl < Formula
  desc "Brings the Terraform cli experience to AWS Cloudformation"
  homepage "https://github.com/rogerwelin/cfnctl"
  url "https://github.com/rogerwelin/cfnctl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8e987272db5cb76769631a29a02a7ead2171539148e09c57549bc6b9ed707be3"
  license "Apache-2.0"
  head "https://github.com/rogerwelin/cfnctl.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X cli.version=#{version}"), "./cmd/cfnctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cfnctl version")

    ENV["AWS_DEFAULT_REGION"] = "us-east-1"
    ENV["AWS_ACCESS_KEY_ID"]     = "dummy"
    ENV["AWS_SECRET_ACCESS_KEY"] = "dummy"

    (testpath/"test.yaml").write <<~YAML
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
    YAML

    output = shell_output("#{bin}/cfnctl validate --template-file test.yaml 2>&1")
    assert_match "ValidateTemplate, https response error StatusCode: 403", output
  end
end
