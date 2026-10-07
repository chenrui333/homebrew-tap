# framework: cobra
class Terracove < Formula
  desc "Recursively test a directory tree for Terraform diffs and coverage"
  homepage "https://github.com/ElementTech/terracove"
  url "https://github.com/ElementTech/terracove/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "6790f897ba830886d66748fcaf0a484ef6a062658898931415dd600428ed4a23"
  license "MIT"
  head "https://github.com/ElementTech/terracove.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94de9b7e1fa9dd8f97cac445a11fe0312cb3adb98bb9ddd7a844a661110687e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94de9b7e1fa9dd8f97cac445a11fe0312cb3adb98bb9ddd7a844a661110687e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a38b82816851e0f4738b718c819c3fca13942dc8d3ae69196a0f1491badfcf4"
    sha256 cellar: :any,                 x86_64_linux:  "20bcfd6a3e7b0adfd50c1f48696be057a819f8d5f07d44132719e7e2a9cdd1d4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
