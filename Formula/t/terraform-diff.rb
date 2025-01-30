class TerraformDiff < Formula
  desc "Always know where you need to run Terraform plan & apply"
  homepage "https://github.com/contentful-labs/terraform-diff"
  url "https://github.com/contentful-labs/terraform-diff/archive/fe1dae3968bcc7d4520626da18526380e685460d.tar.gz"
  version "0.0.0"
  sha256 "41192ddcfb2f2d01255e166f779f7cb85576c78ebf183d432e398fce0403e2cd"
  license "Apache-2.0"
  head "https://github.com/contentful-labs/terraform-diff.git", branch: "master"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"terraform-diff", "-h"
  end
end
