class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "cf6c7c772dac2bee898bbe026dd6428814e07652c297861cd484993b18acd3b4"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1225784ff676b6ac76a55934d46d94e2a8db514627a7f97efde131c22bd1d1fc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1225784ff676b6ac76a55934d46d94e2a8db514627a7f97efde131c22bd1d1fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1225784ff676b6ac76a55934d46d94e2a8db514627a7f97efde131c22bd1d1fc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc0e1d503a697af40dcdc7986c18309d9844804d8b6c193b5a72cb67a5e4f570"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7800fec68e23ae20af5035aaa2735dca82caecd75a26206676831db39644e4a"
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
