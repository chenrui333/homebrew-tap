class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "18cb5722f87a637756be3cd8ebdf16fd2ab2cc7b76ae096d930499a3d7e8e977"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58adb3af7466e7fd5ec010588f1e8faacc11e95eee7d64164812a7d321d4530c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ab5a725305ac61663a68c16b617d6ce8a0529a4c5374a15d5a8dde8637574b2"
    sha256 cellar: :any_skip_relocation, ventura:       "7badb0f976b2fb1470e8f61d6836085f804a7335f1934b649d23393bc0d8b594"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "773b4e4a48eba748ca5d2db70be7d231edb5a754333a30a65409dde0b25ade09"
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
