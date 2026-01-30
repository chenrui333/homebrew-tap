class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "dd3f88f7048ef065c7f497176d3e7f92123450574c84bb3114f2ebdce88e6169"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "abbc37728afa82e6f183583ca28dd605494643eb2a1450a6eff4b01ad132caea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "abbc37728afa82e6f183583ca28dd605494643eb2a1450a6eff4b01ad132caea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abbc37728afa82e6f183583ca28dd605494643eb2a1450a6eff4b01ad132caea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15aba3138649191057c4e7d570f4a9ca8d95bedc62483640099909e33f234cb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d59e2453f391f90fe30109b773cf07b4afc78d9a414f0140c1771c1bdf03fd34"
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
