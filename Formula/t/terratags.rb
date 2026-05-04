class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "cf6c7c772dac2bee898bbe026dd6428814e07652c297861cd484993b18acd3b4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d435e1c84967fd82def663237c9b0b738b7032c87ef4262ad6b00b5ede3a06f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d435e1c84967fd82def663237c9b0b738b7032c87ef4262ad6b00b5ede3a06f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d435e1c84967fd82def663237c9b0b738b7032c87ef4262ad6b00b5ede3a06f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15983e2525396d843154a598b2d2a852f39afb967e9e3dcd7f78ce8ecde8b301"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b2bbebeaee792549a6cc25e1729a9d9cd0dec2563617018051c0c07378edf6b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terratags --version")

    (testpath/"ok/main.tf").write <<~HCL
      resource "aws_s3_bucket" "x" {
        bucket = "example-bucket"
        tags = { Name = "ok" }
      }
    HCL

    (testpath/"terratags.yaml").write <<~YAML
      required_tags:
        - Name
    YAML

    output = shell_output("#{bin}/terratags -config terratags.yaml -dir ok")
    assert_match "All resources have the required tags!", output

    (testpath/"bad/main.tf").write <<~HCL
      resource "aws_s3_bucket" "x" { bucket = "bad-bucket" }
    HCL

    output = shell_output("#{bin}/terratags -config terratags.yaml -dir bad", 1)
    assert_match "aws_s3_bucket 'x' is missing required tags: Name", output
  end
end
