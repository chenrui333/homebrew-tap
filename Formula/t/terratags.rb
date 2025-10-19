class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "5241ecaac9353ffbb8b707e728f4ad990924b8567b9ed395621051b670d920a3"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34c33ead25393dcd34fe4458b6003af235fb45e54bf073ae46a3be9dd4c6ea9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34c33ead25393dcd34fe4458b6003af235fb45e54bf073ae46a3be9dd4c6ea9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c33ead25393dcd34fe4458b6003af235fb45e54bf073ae46a3be9dd4c6ea9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f6a852aabc188e59df36977df6a7c97f6294e4c4951f34ae228a8c482561d9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6548e134054b516ec64a27c4f479c11519098395d2231e4ba4c7e1c3cc92f244"
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
