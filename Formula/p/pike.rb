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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80c0c745438ac3b52cd91b254d5535158bc22188212439b3254519aec84b5723"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "80c0c745438ac3b52cd91b254d5535158bc22188212439b3254519aec84b5723"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba8a88b5a30143a53590825ca63033d8fd5283f62567fc00b0704605db9b84d"
    sha256 cellar: :any,                 x86_64_linux:  "2bd12d9439f1da75bbd23cbfff8bef1a39ff14ab009dc1fb7fee8d944382c793"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X github.com/jameswoolfenden/pike/src.Version=#{version}"
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
