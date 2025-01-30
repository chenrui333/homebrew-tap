class Terracove < Formula
  desc "Recursively test a directory tree for Terraform diffs and coverage"
  homepage "https://github.com/ElementTech/terracove"
  url "https://github.com/ElementTech/terracove/archive/refs/tags/v0.0.7.tar.gz"
  sha256 "6790f897ba830886d66748fcaf0a484ef6a062658898931415dd600428ed4a23"
  license "MIT"
  head "https://github.com/ElementTech/terracove.git", branch: "main"

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
