# framework: cobra
class Dbin < Formula
  desc "CLI tool to produce MD context files from many sources"
  homepage "https://github.com/xplshn/dbin"
  url "https://github.com/xplshn/dbin/archive/refs/tags/1.0.tar.gz"
  sha256 "c1e5925af2521d34bd70e6e61eb100db99da80adf0cc495b0c90263841127719"
  # RABRMS is not a valid SPDX-License-Identifier
  # license any_of: ["ISC", "RABRMS"]
  license "ISC"
  head "https://github.com/xplshn/dbin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70d9e18419f50fe98c186d5fb8be2a7acd2bc7b7a0b4a6112903ed669a2847e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e6bbcc10ba13f16365358f8500c10dceb81a2fd8fd784ddfc4b8a7b54d63431"
    sha256 cellar: :any_skip_relocation, ventura:       "716d5d02f566093b12d45c0182e3bbc14008e0ebf5153995a566865478d0f58f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb6437c85b2b3b577fa5cc78d638d0cc6399ba5d0c14ec4de63ecd164a063ccc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dbin --version")

    output = shell_output("#{bin}/dbin del bed 2>&1")
    assert_match "Failed to retrieve full name for 'bed#'", output
  end
end
