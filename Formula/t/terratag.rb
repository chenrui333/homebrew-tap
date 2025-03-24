class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "18cb5722f87a637756be3cd8ebdf16fd2ab2cc7b76ae096d930499a3d7e8e977"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "25bbe81c76bf5272ea22f3a61d70ddf1fdb16974c98113d91498b7abdcd4203c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84911509d579939aad197d50454cf518f41e57188730e81ebc708e8a7ab0aa69"
    sha256 cellar: :any_skip_relocation, ventura:       "2ddaafa26fa7cd98b5ce96af804b92dfe32c4c0132055577f1b2c6559902f60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa8ad7ab638c330135dc503335c3e2225688c724a87efeac845b8e707218ef8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terratag"
  end

  test do
    # version print as `vdev`, see upstream bug report https://github.com/env0/terratag/issues/168
    system bin/"terratag", "--version"

    (testpath/"main.tf").write <<~EOS
      provider "aws" {
        region = "us-east-1"
      }

      resource "aws_instance" "example" {
        ami           = "ami-12345678"
        instance_type = "t2.micro"
      }
    EOS

    system bin/"terratag",
      "-dir", testpath.to_s,
      "-tags", '{"environment":"test","owner":"brew"}',
      "-rename=false"

    output = shell_output("#{bin}/terratag -dir #{testpath} " \
                          "-tags '{\"environment\":\"test\",\"owner\":\"brew\"}' -rename=false 2>&1")

    assert_match "terraform init must run before running terratag", output
  end
end
