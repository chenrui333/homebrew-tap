class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "a5a5518923c4ded9002b586551e21e00debcfe49a240fbe8c5d6408950d10175"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2321689a48a1d073a275448b27c8f627ad87deb545d795520327265e0a914f22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2321689a48a1d073a275448b27c8f627ad87deb545d795520327265e0a914f22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18b94de246ae6de41b6a0880e3cdddde0150543465adcf1705382bebb541df8b"
    sha256 cellar: :any,                 x86_64_linux:  "0da277d57d35803b883b182a212b305c725ec8410e9b08bdb3e6efe604c77b36"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
