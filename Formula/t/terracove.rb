class Terracove < Formula
  desc "Recursively test a directory tree for Terraform diffs and coverage"
  homepage "https://github.com/ElementTech/terracove"
  url "https://github.com/ElementTech/terracove/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "6790f897ba830886d66748fcaf0a484ef6a062658898931415dd600428ed4a23"
  license "MIT"
  head "https://github.com/ElementTech/terracove.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d7273e1a473065d6d90771a6d8a13305760c79e3e55e7ad7c64af2f71ff3b35"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ba0c2bf5b99fe81ffcb71476ad5853c3b9548d1faa16bbe656481508bb5ecbc"
    sha256 cellar: :any_skip_relocation, ventura:       "921d2ee496fd586ea8797878e2c72ba70a3c7f610f69fd244c486b31175928d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b91fc58598410ed3100ff8250c431e934e8443afba9b81f3c8fa34b23d2e478"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terracove --version")

    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 4"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }
    HCL

    assert_match "Terraform Diff Report", shell_output("#{bin}/terracove #{testpath}")
  end
end
