# framework: urfave/cli
class Pike < Formula
  desc "Tool for determining the permissions or policy required for IAC code"
  homepage "https://github.com/jamesWoolfenden/pike"
  url "https://github.com/JamesWoolfenden/pike/archive/refs/tags/v1.0.12.tar.gz"
  sha256 "f999c4ea3b6cbfc6e774f03571e0a09db89fc8e0e9f91bfed46127f2601450ba"
  license "Apache-2.0"
  head "https://github.com/jamesWoolfenden/pike.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c6a5e6e44045f561c1e8748460ddf971b3607e9e321602327bfe092589fe851a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6a5e6e44045f561c1e8748460ddf971b3607e9e321602327bfe092589fe851a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19639ce76470bb6c5eeea8479deec8442636ebba45e053960182b321a6004afa"
    sha256 cellar: :any,                 x86_64_linux:  "dcacdab78e531dc7f755c87aa5835d4f67e7300cf36e02e93647f0acb5515331"
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
