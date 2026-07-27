# framework: urfave/cli
class Pike < Formula
  desc "Tool for determining the permissions or policy required for IAC code"
  homepage "https://github.com/jamesWoolfenden/pike"
  url "https://github.com/JamesWoolfenden/pike/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "fb49d4ba3afcf1dbe576ebf43ff9b20df2a5c48e83487524d0fb48cb204e0078"
  license "Apache-2.0"
  head "https://github.com/jamesWoolfenden/pike.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "920b8594b257f0ccd8b14f00a9ab416e496355c4f34ebd55b6fb6557cc74bdb5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "920b8594b257f0ccd8b14f00a9ab416e496355c4f34ebd55b6fb6557cc74bdb5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "920b8594b257f0ccd8b14f00a9ab416e496355c4f34ebd55b6fb6557cc74bdb5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2e6e6e864db4420c7615ead69f5a3f3d8bfee2ef8a943089f1b282331c2d863"
    sha256 cellar: :any,                 x86_64_linux:  "ed2dcf1b04dc85a5a67cb296d179949e67583dbe1dbec5604a549a071d0b7cde"
  end

  depends_on "go" => :build

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
