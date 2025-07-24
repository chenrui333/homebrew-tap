class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ae27b37043126bd18271e157018fc49b826fdbe8346d2074dddc83bf771c8e6b"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8b9375c8d180eed61d44f2719381616ebd194abf2ff50d4a74dc27926caa486"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65f5f6940cc2c136b645f1bd04effe12972bb590527f77dabab6ebf0028f519a"
    sha256 cellar: :any_skip_relocation, ventura:       "eeaef96c67a0d22c4d8296635f30fefab9ddc9f3eceaca8d0c06373ac335a349"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991890288264cbb38881e510083940866d5be24b2839178230bf0355d106ceb9"
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
