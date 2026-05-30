class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.24.0.tar.gz"
  sha256 "23619a8a8e1f9c1c95d417df3a5422048f9ef7a88c2dc9768412d4debffc91b6"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eacb329d406ba9f55bbcb585179c07150580b99e5e8732a914297fad5434cd7b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7762b568ea0550d1c13ffa2b2894cd61de30a81d820e71991a44acadff7aa460"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bca362abbff3dcecbd6e0c4c2cd82d22f2bbd73ead3360e1b583cd499e479305"
    sha256 cellar: :any,                 arm64_linux:   "c65e46cabf591c8fa224fce4367e3d2adeabe0b6ecc9223d9e7ee7d354920f2c"
    sha256 cellar: :any,                 x86_64_linux:  "316d5517e95423392a0f69352ea2b77974cff857f0e5d77082387acff4ae5575"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
