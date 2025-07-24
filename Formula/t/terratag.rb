class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "ae27b37043126bd18271e157018fc49b826fdbe8346d2074dddc83bf771c8e6b"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b00379765fad1e9603dafc6bf45c3610c6a8c2ee4ad0fde41683934f2647ff46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c31c014ce9517ad3a854399b4887271f9fd8882048c006b7767dc5aacd6a68ef"
    sha256 cellar: :any_skip_relocation, ventura:       "c9af195c0182650c40da2a03679a08f52d6d9951b75049d708ae9b46db6989cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecba91cf3499d70bb57a62bb3e89f88dcbb990f3868bec6a6d458f6e1a866d39"
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
