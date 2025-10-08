class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "09a240210158ab578a90e805820a9e89f874796d45f9607efc83e783cf979cf1"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3f6b44fc9576a7ff71d8ad27bf9551661f12e2b9b6d6777b0f05a41dd46b388"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ef51a4617443c3ecc5e32001d1c475d2c001ae2f1ef03990604d898b6d594c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ece1c6cb117fc0479a2ee35206bbaf64d87d6d502636f0476570e075febb973b"
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
