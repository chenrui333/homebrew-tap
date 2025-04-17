class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "0ab43f36247a1e503fa5135e37a1e4226184dcea5e14e37bdb71437baabee193"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d0e360df1a57f5430c9931e4d2808fee25c708231069f92c55bdf2e7f5f80aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2f86755413a2514491d0bdbb39add0e56274ae0ddcbfe5d085dd7c986f909d06"
    sha256 cellar: :any_skip_relocation, ventura:       "bca85da128e5c2231d3ec750fb46f6577638aa232a9a6f8842f1af06c587ed2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f16df22beb2468375eae8f65da3d63cce0c049d8f18239179ae0ef777fd60190"
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
