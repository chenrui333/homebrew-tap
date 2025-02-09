# framework: urfave/cli
class Cfnctl < Formula
  desc "Brings the Terraform cli experience to AWS Cloudformation"
  homepage "https://github.com/rogerwelin/cfnctl"
  url "https://github.com/rogerwelin/cfnctl/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "8e987272db5cb76769631a29a02a7ead2171539148e09c57549bc6b9ed707be3"
  license "Apache-2.0"
  head "https://github.com/rogerwelin/cfnctl.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5511eb9fba78329a56363f5013c9a52ed1289dcab7bfd4e382d263567ab62f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d863a5d001213308d12517d81ce31439783f4b61b50bed5718d0957e5ee9770"
    sha256 cellar: :any_skip_relocation, ventura:       "ed504c3ef9cb8a3eaa0ad0e6df8869eb3141dd8de83bf354b55184e7fb71cce5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cd40a3fb91a6171a3ff08c23ae9c9c17e8474c707dccd0e0242b2d68815f781"
  end

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
