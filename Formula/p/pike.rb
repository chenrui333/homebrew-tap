# framework: urfave/cli
class Pike < Formula
  desc "Tool for determining the permissions or policy required for IAC code"
  homepage "https://github.com/jamesWoolfenden/pike"
  url "https://github.com/JamesWoolfenden/pike/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "da0fa4c61672d792d0819122463a54b2da0ababd4ce5a3ecb40946de632b7822"
  license "Apache-2.0"
  head "https://github.com/jamesWoolfenden/pike.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0bf3afb434e7f99b899e7c0445d8f49dbed9db78262ef80b1f565a360ee8ca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0bf3afb434e7f99b899e7c0445d8f49dbed9db78262ef80b1f565a360ee8ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f945ed48cca99d0394e6a2c4acfc3e6b18883682daabeb0af556167329cbb293"
    sha256 cellar: :any,                 x86_64_linux:  "898cdea21a6eb1c1dcd2ae82ac4f09453dbc4de71c136847a1f6790698dc93f7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/jameswoolfenden/pike/src.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pike --version")

    (testpath/"test.tf").write <<~EOS
      resource "aws_s3_bucket" "example" {
        bucket = "pike-test-bucket-#{Time.now.to_i}"
        acl    = "private"
      }
    EOS

    output = shell_output("#{bin}/pike scan -d .")
    assert_match "s3:CreateBucket", output
  end
end
