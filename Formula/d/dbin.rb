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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5e6485e8bba88a3e4f7fad23943797936e5399bcbb27abec8858c0639a91f08"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4801254a74041fcadc40f3d51f15f9290a9044f189d59cbaaa03560263001ce1"
    sha256 cellar: :any_skip_relocation, ventura:       "ca60b124db63d9c6021e3631c56ec3d0944f83149204f01fb3f5e0d3ec779918"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aac35a5e149ce87973544ed39a661568d691a02b35475ff985b4fa004432174"
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
