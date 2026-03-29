class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "82476ca874d5209a71e84fe3eecb81204c9931be1bfdcbf67e4034b8815ed6ff"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ab96f12583100e2a233e9d5c57550dc89f40bcf15cf14a8f3f9be681713f55d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ab96f12583100e2a233e9d5c57550dc89f40bcf15cf14a8f3f9be681713f55d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ab96f12583100e2a233e9d5c57550dc89f40bcf15cf14a8f3f9be681713f55d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "28c37d5b2fce06e7e016fd8f7fb79447e3e0a0a9df51a1cd41e8bddee0857c8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5b345c6fa82616871ce5977c9d68481b7bbeb8c5afc696506c78461bc86e261"
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
