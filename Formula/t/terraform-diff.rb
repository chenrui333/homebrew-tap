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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "094d3cbcbefd7ef7c7118576ce8bb246c8c864a4fb136e7db05dada9efbec555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094d3cbcbefd7ef7c7118576ce8bb246c8c864a4fb136e7db05dada9efbec555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a61c5251217a9890e807ea917440f3d9cd2da17253016f37c0c0e2cc64adfe3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4549d29ed4e20b8d8a883cc620b3276a11d48e407d90f29ffd708dd064f8ad0"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"terraform-diff", "-h"
  end
end
