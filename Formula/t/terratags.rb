class Terratags < Formula
  desc "Required tags validation on terraform resources"
  homepage "https://terratags.github.io/terratags/"
  url "https://github.com/terratags/terratags/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ba0ceffa8a57d6cadc4c3bbea0f8d1c911dbdb1d871b7a291b6bee51dcff5add"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e88143e05b5c1865458d7bfe0dae15d6b1c13d495f6c7cad6eddabe9b6652a6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e88143e05b5c1865458d7bfe0dae15d6b1c13d495f6c7cad6eddabe9b6652a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e88143e05b5c1865458d7bfe0dae15d6b1c13d495f6c7cad6eddabe9b6652a6f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc4ef6ed480be9022f7829c35332332f375eea2ecae0ef4d8aeb6b7fd4143562"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8720b60936404ee2291eebc3aee6c9a599d043b8e969ba3cd593da55dd5d352"
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
