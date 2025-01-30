class TerraformDiff < Formula
  desc "Always know where you need to run Terraform plan & apply"
  homepage "https://github.com/contentful-labs/terraform-diff"
  url "https://github.com/contentful-labs/terraform-diff/archive/fe1dae3968bcc7d4520626da18526380e685460d.tar.gz"
  version "0.0.0"
  sha256 "41192ddcfb2f2d01255e166f779f7cb85576c78ebf183d432e398fce0403e2cd"
  license "Apache-2.0"
  head "https://github.com/contentful-labs/terraform-diff.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a214ec7d848d7a2d2fa0f517fb8731cf3402647dd28dcbac997b5ab60e58e6cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d00c9f08b4c0739e56a64403d4f78b7b53818d701106df40e1f14df28669716"
    sha256 cellar: :any_skip_relocation, ventura:       "719e8ffb7971d5a81615da22e25c71e63b0097affc2a0102494e653f78288b0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913efb8bee3baa2442e4e0bf9dfe4d9a4183ee00416c6f735326e8e180c7d46d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"terraform-diff", "-h"
  end
end
