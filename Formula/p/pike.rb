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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c26c65faab305be5fac6e76f5df540118759964c8faebb510f174e5e8cdb7842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c26c65faab305be5fac6e76f5df540118759964c8faebb510f174e5e8cdb7842"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26c65faab305be5fac6e76f5df540118759964c8faebb510f174e5e8cdb7842"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3e8df2f54c499f39329d97ec9ad34555adcdf8ff40a73e77fc1a5ca0cdd1df"
    sha256 cellar: :any,                 x86_64_linux:  "8c90a1c8e39323688a9a1b484f207ba4d077cf6f8068612cbf0b6e2519b009e2"
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
