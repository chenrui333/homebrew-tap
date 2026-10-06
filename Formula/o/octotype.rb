class Octotype < Formula
  desc "TUI typing trainer inspired by monkeytype with a focus on customization"
  homepage "https://github.com/mahlquistj/octotype"
  url "https://github.com/mahlquistj/octotype/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "5015c5e9a53609ce5554f98c814b37f6dde0e3b3c515b453bfc1e7999d6a66bc"
  license "MIT"
  head "https://github.com/mahlquistj/octotype.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0a7483695b94994e4a7395c2ceaa93d8b4a67c877621928b97e00124b243189"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034261389d02291728e3c4e4be42dbf7bf1e395b31de05e1e7d58808c55671c7"
    sha256 cellar: :any,                 arm64_linux:   "02f467bc8945f993e8bffcd896363a16385556fdf8659bcd65966a113fe95d0b"
    sha256 cellar: :any,                 x86_64_linux:  "e30f4a77fa69617a26abb9ed9e91e28515f6703161462e2d69afcbe4147cc1d1"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/octotype --version")

    output = shell_output("#{bin}/octotype --print-config")
    assert_match "disable_ghost_fade = false", output
  end
end
