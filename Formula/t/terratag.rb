class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "57101a2a4ad55bb5d992eb2bef54f56ac9efba926c3bac5d7728351e4975ff27"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfe06e52b82c3678f64ce179f0a3d6a3997d98b408597fc1567f26efda8e1970"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "80bc57d68008a8d0da99d1487b179809c749b24dc16296fbdf873232c939cf88"
    sha256 cellar: :any_skip_relocation, ventura:       "b36375531e0e42995955f4fcc51b52a92f503c25afa71d7047ab555ebe11a235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b71f54cdb75a2a73874d95d3774799254383ed41dd5758da18998c0dd1377acb"
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
