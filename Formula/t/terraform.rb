class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.11.0.tar.gz"
  sha256 "c40b484ad84d1461e15e4c8f1d45ef85b85941fde30f5fa69126f3720dad77c0"
  # license "BUSL-1.1"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3765b995277c2f464c7393d5b9686821f7670da4c32da6e3775d53e1ac520362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8c5b079844f5b34ec26e1c6f251f851e65a7d1279e4f12415598f6abfea7820"
    sha256 cellar: :any_skip_relocation, ventura:       "49f7654972086bef804a01769623e16d5d021539d927d24810eef90dd70b24c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d58734c14c2f1ff0a95714f8aa1a51a22077f6531e0f1e77c9feeea29ac2646a"
  end

  depends_on "go" => :build

  # copy over from `terraform.rb` in core tap
  conflicts_with "tenv", because: "both install terraform binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform version")

    minimal = testpath/"minimal.tf"
    minimal.write <<~HCL
      variable "aws_region" {
        default = "us-west-2"
      }

      variable "aws_amis" {
        default = {
          eu-west-1 = "ami-b1cf19c6"
          us-east-1 = "ami-de7ab6b6"
          us-west-1 = "ami-3f75767a"
          us-west-2 = "ami-21f78e11"
        }
      }

      # Specify the provider and access details
      provider "aws" {
        access_key = "this_is_a_fake_access"
        secret_key = "this_is_a_fake_secret"
        region     = var.aws_region
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami           = var.aws_amis[var.aws_region]
        count         = 4
      }
    HCL
    system bin/"terraform", "init"
    system bin/"terraform", "graph"
  end
end
