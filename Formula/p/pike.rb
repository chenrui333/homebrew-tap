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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "998cfebaa2f8d21aaa9fa4e9eab53980efe26f21234a8d5ca5419dc44840654f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "998cfebaa2f8d21aaa9fa4e9eab53980efe26f21234a8d5ca5419dc44840654f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "998cfebaa2f8d21aaa9fa4e9eab53980efe26f21234a8d5ca5419dc44840654f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "466686b791dd4c35424bbd19e222933ff9c5f8629c0ac9a8e6a1c73c18bf2274"
    sha256 cellar: :any,                 x86_64_linux:  "0241dc764801a3be7548dcb7bea25a7f59d9dbc53d308380a2c21538057282fb"
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
