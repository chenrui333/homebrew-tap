class TerraformCleaner < Formula
  desc "Tiny utility which detects unused variables in your terraform modules"
  homepage "https://github.com/sylwit/terraform-cleaner"
  url "https://github.com/sylwit/terraform-cleaner/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "61628133831ec667aa37cd5fc1a34a3a2c31e4e997d5f41fdf380fe3e017ab55"
  license "MIT"
  head "https://github.com/sylwit/terraform-cleaner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fc3085d16e7c68b5cdfb0234af758e82bd0a43a87ae787b0d7c8564b400a663"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37f78830295fcdebb8913882f5261e1d1b9ad4c1c378aa60e30a7980068d0420"
    sha256 cellar: :any_skip_relocation, ventura:       "be6a273e545cd2511f93a774844ff5783a20e30d830e52d85d0f09c285e6eca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ed8122e8c98e02ff771eb920a90b7c8b5fc75c9f834b82118d109214902de08"
  end

  depends_on "go" => [:build, :test]

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.tf").write <<~HCL
      terraform {
        required_version = ">= 1.0"

        required_providers {
          aws = {
            source = "hashicorp/aws"
            version = "~> 5"
          }
        }
      }

      provider "aws" {
        region = var.aws_region
      }

      variable "aws_region" {
        type    = string
        default = "us-east-1"
      }

      variable "foo" {
        type    = string
        default = "unused"
      }
    HCL

    output = shell_output("#{bin}/terraform-cleaner --unused-only")
    assert_equal <<~EOS.chomp, output

       🚀 Module: .
       👉 1 variables found
      foo : 0

      1 modules processed
    EOS
  end
end
