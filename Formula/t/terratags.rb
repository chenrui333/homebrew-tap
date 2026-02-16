class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "b7020f20208029cb341b4bd6b4668f2de152ab9326f46198dfd8434631f94bac"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3910ebddd79d5293f3b7c4eac84ec30d324f914e34ca63f4e65bea6909b13a1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3910ebddd79d5293f3b7c4eac84ec30d324f914e34ca63f4e65bea6909b13a1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3910ebddd79d5293f3b7c4eac84ec30d324f914e34ca63f4e65bea6909b13a1e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bc1abee9d841e7d4f41a5bff925e4f9622f9215563a77dacd5623d8d1806866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcbc23633072bb33d25facdb4ad38e5d11759277b973726757052554204fd124"
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
