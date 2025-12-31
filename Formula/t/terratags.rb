class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ba0ceffa8a57d6cadc4c3bbea0f8d1c911dbdb1d871b7a291b6bee51dcff5add"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0af4661896d70759084c50de824069b4cd5d8b4eb27aba6591290d2c23835d2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0af4661896d70759084c50de824069b4cd5d8b4eb27aba6591290d2c23835d2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0af4661896d70759084c50de824069b4cd5d8b4eb27aba6591290d2c23835d2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a974daab5b264ba3b47781c0c299e08402fafa308fda0e52c6489de676123aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "241f4b854a239112de9a52b268025844fb276b99fc2c128d66e41af60675d8be"
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
