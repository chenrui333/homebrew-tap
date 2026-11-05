class Oyo < Formula
  desc "Step-through diff viewer"
  homepage "https://github.com/ahkohd/oyo"
  url "https://github.com/ahkohd/oyo/archive/refs/tags/v0.1.66.tar.gz"
  sha256 "8b238bc783e5c1503f6de991198bc59078962ce52d2ca930043393fcb795cb56"
  license "MIT"
  head "https://github.com/ahkohd/oyo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3035a39e82f77bfe300cf428e730083b1db986e6ed1d3f0facae711d0e6488e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf654bbc786dbdf361f99b7a27fc1dcd4fce5f0dc05557d6c5efb9fdb9c9ef59"
    sha256 cellar: :any,                 arm64_linux:   "688060c7a5942c94c8aa65cb61544217fdc463407e05a2cc4cdb863ada85a420"
    sha256 cellar: :any,                 x86_64_linux:  "f837b911201d00402f0c9e43516a2f8758ee29ebfa895ef7d3936520d6374c9a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "oniguruma"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/oyo")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oy --version")
    assert_match "github", shell_output("#{bin}/oy themes")
  end
end
