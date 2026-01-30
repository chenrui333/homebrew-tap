class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "dd3f88f7048ef065c7f497176d3e7f92123450574c84bb3114f2ebdce88e6169"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e3b55119027f3d53a02a92bed36184568939322e0176e1c01be45f5316c0d2cd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3b55119027f3d53a02a92bed36184568939322e0176e1c01be45f5316c0d2cd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3b55119027f3d53a02a92bed36184568939322e0176e1c01be45f5316c0d2cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "86fe36ae942993ef6fc4e6da387d31c5c1e60ad2c83aa1cc43eca8b568fb3fba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ae2d0de0607b9e4aac9d1d078e1492ee3f8282c9e4b2bf80aaeb0ff854d5320"
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
