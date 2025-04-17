class Terratag < Formula
  desc "CLI to automate tagging for AWS, Azure & GCP resources in Terraform"
  homepage "https://www.terratag.io/"
  url "https://github.com/env0/terratag/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "0ab43f36247a1e503fa5135e37a1e4226184dcea5e14e37bdb71437baabee193"
  license "MPL-2.0"
  head "https://github.com/env0/terratag.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbf2f6a692fe61bfa31a464041347c40b3a4b3a6668de80e2efdf954ca4299c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e64bc1026be2b240722db7b3c939a467abd0c4105d6c99e42995c17839924211"
    sha256 cellar: :any_skip_relocation, ventura:       "d5dc80be4da6dbd7cce473295e4ce3d3fdc85c3a182dae7de57b5cc384d3663c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e664cba486bf65006368a1d914d748a0792a6e02ae9e8cc9562d42a0b31cda4"
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
