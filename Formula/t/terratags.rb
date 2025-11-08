class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "8da1873cd07ed8e53ac457dba0859673337dd416880af6b77d616c558d95274d"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4babb48b4f21fcc8c08a49009821ec59454ef26136c28ad5fff23b5138a2a991"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4babb48b4f21fcc8c08a49009821ec59454ef26136c28ad5fff23b5138a2a991"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4babb48b4f21fcc8c08a49009821ec59454ef26136c28ad5fff23b5138a2a991"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "851c8cfded122942630b2cb139c1abfaf5cb3ac197dd4b4a1e8b6f263e3e784d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "139c1acf59c920f38f744b4534079539257d6db1213b0c6725914ae8a2fe92a8"
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
