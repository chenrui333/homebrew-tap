class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.6.tar.gz"
  sha256 "887ee98f7f68543cc08ecfe0a8eeb019687d792124d94ae54d494cf68db1bd6b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e981d26e39692bf1f59a4bce5a771fce44b0fc94911942169e6b3c7e45845878"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e981d26e39692bf1f59a4bce5a771fce44b0fc94911942169e6b3c7e45845878"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e981d26e39692bf1f59a4bce5a771fce44b0fc94911942169e6b3c7e45845878"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "53a585e27bf9f18047ea711686f4ed05e55a890c8d9464ff2d804c6b9f79c249"
    sha256 cellar: :any,                 x86_64_linux:  "b11584601d44e4b01304090b24cff429ee557fb8509e355664333f5f20c16e1b"
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
