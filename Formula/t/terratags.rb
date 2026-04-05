class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "1b5ac2f89bdbc0b1aa42e95c4d6edcaf56adc4cdbd78538925c1b25cca149468"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4c4fcecf9b65231888a7f723035df27b445648912d8aa05d28ffac9a05e53e9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4c4fcecf9b65231888a7f723035df27b445648912d8aa05d28ffac9a05e53e9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c4fcecf9b65231888a7f723035df27b445648912d8aa05d28ffac9a05e53e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1392b03631435216448470876535b07e84ef768d1da2af366d5890d8d69a8a21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2183c08663f11dcc2bfdac25f46f7727e34ac03e39cd7bd7a75098be1cbc9a99"
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
