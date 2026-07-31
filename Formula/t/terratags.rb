class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "a5a5518923c4ded9002b586551e21e00debcfe49a240fbe8c5d6408950d10175"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "00a2c49a34fde86917e8c09bfb90f473b8ba3f77febd01553f77a367ded96dd4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00a2c49a34fde86917e8c09bfb90f473b8ba3f77febd01553f77a367ded96dd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "00a2c49a34fde86917e8c09bfb90f473b8ba3f77febd01553f77a367ded96dd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbba8855057feeaed4dd36eb6ea68d7729942578b40a5f70c9a62c2bbfb73d64"
    sha256 cellar: :any,                 x86_64_linux:  "38be67af283c325673f2311cef280f9f678e076e28b0d7978ece0fbf63b0cf60"
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
