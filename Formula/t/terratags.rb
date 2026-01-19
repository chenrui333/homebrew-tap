class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "1cdcfdb4ca21fd3318c841030c359c758bcfe12b901934e195fb3839d69b5995"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "462fe0e5f3725648f175cc5fec6ea0fd3a74e71410747e6dcde0f6074ed36bfc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462fe0e5f3725648f175cc5fec6ea0fd3a74e71410747e6dcde0f6074ed36bfc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462fe0e5f3725648f175cc5fec6ea0fd3a74e71410747e6dcde0f6074ed36bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9cfcc8a405be971d39e86348d1fc952b1a46298d9bec9cfcf80b5eb7d6e88a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf9cfc948ae2dc60356521022d8a6f97cb6e106ebd9a06b7f8e75515e33b1d8d"
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
