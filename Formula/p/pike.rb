# framework: urfave/cli
class Pike < Formula
  desc "Tool for determining the permissions or policy required for IAC code"
  homepage "https://github.com/jamesWoolfenden/pike"
  url "https://github.com/JamesWoolfenden/pike/archive/refs/tags/v1.0.14.tar.gz"
  sha256 "2f7fc7f51d3a44b83f426087a8fa9cf8db29ce515f66242042f56853bf9044d4"
  license "Apache-2.0"
  head "https://github.com/jamesWoolfenden/pike.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57efdb2d07883459960626edb58786d8d45529947347cf894c67bfaabd94021b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57efdb2d07883459960626edb58786d8d45529947347cf894c67bfaabd94021b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5f6b4d7002af2493b790cfe26379f97c4650409957e25be3f56f3d84098459f"
    sha256 cellar: :any,                 x86_64_linux:  "0305c719caf97d72883f5c6a306dcfa57de7e6cb810f49ca0e642ff915935794"
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
