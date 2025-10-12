class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "2dd6b81214ef259d734773c1ef28d447e641036289e8118edc62fb3167aa8b93"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa7903d2fc12e85f5582b5755b7378abb1088e085f68d8ee6b54e77f0223881b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa7903d2fc12e85f5582b5755b7378abb1088e085f68d8ee6b54e77f0223881b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa7903d2fc12e85f5582b5755b7378abb1088e085f68d8ee6b54e77f0223881b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd8fa5a8f07345c7c097eef3fb81c8dc05f0a9857412d4e819abdabbf6239f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d11953f5205a324473682b4a443cc336ccc71950dc74cfcff3ff598cd795d41"
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
