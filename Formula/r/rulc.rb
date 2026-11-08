class Rulc < Formula
  desc "REPL and terminal calculator with plotting support"
  homepage "https://github.com/imizgun/rulc"
  url "https://github.com/imizgun/rulc/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "929c93d987baf96177503b5148b588c993179f5eb2eebdec3d136ae3e5ddcc79"
  license "GPL-3.0-or-later"
  head "https://github.com/imizgun/rulc.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c2376066bbd9b4c18bee6ee0723ed36c3c4f68b8a8c3bcdb9e86694af20142b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afe0719022e5aae5403c02fd16d4f025dc01f8353b621e55515114057a8ca433"
    sha256 cellar: :any,                 arm64_linux:   "c2ee53264ef72f1ffe1e7d07ea128991c9985749e3d8f4285e931ab536054616"
    sha256 cellar: :any,                 x86_64_linux:  "5cf0e0509d1983a12535f258fa73a0e7df15f83bd8073fc695fa63bbb56e4354"
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
    assert_match version.to_s, pipe_output(bin/"rulc", "", 0)
    assert_match ">> 14", shell_output("#{bin}/rulc --exec '2 + 3 * 4'")
    assert_match ">> 256", shell_output("#{bin}/rulc --exec '2 ^ 8'")
  end
end
