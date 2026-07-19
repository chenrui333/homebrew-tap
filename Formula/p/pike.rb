# framework: urfave/cli
class Pike < Formula
  desc "Tool for determining the permissions or policy required for IAC code"
  homepage "https://github.com/jamesWoolfenden/pike"
  url "https://github.com/JamesWoolfenden/pike/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "03a9811b8615af59b97f56d1a5b4c6addd3b31c3810080aa169721e1eb4a84e3"
  license "Apache-2.0"
  head "https://github.com/jamesWoolfenden/pike.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2b79a15ce837959d6cae608d1ac29102032aa4cd95b60af83cde7c00403ea11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2b79a15ce837959d6cae608d1ac29102032aa4cd95b60af83cde7c00403ea11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2b79a15ce837959d6cae608d1ac29102032aa4cd95b60af83cde7c00403ea11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dacb81afbaa215b18c1d46201687eb4a7acbed15d807bf8300a65a3d37c6c3b8"
    sha256 cellar: :any,                 x86_64_linux:  "0d219740c872bd973e3784f715450e8fee1ca51c1a5aac60f852feb0bad46ebe"
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
