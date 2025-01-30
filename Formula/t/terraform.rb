class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/refs/tags/v1.10.5.tar.gz"
  sha256 "1c0526360b9b6664a4064058a71a1fbd78b9b4bd0bd56df8c38744abcd57691e"
  # license "BUSL-1.1"
  head "https://github.com/hashicorp/terraform.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc9143c21d70ed25025c1fefe999b8fbfc5f3d16b6cddd42030731c66b4ab39e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "315e51bed8ed65e698fd5e5ca798508c8da843317b860fb2d7abda5e93e5a208"
    sha256 cellar: :any_skip_relocation, ventura:       "83594bd167a48b70f97d7707cbb5c29d1fc41341df0c8709f5328abd065eaa34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4d717bff187649e4ed2dec2b19f0b509e0afaf411639cd34ffd70fb5e5cb314"
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
