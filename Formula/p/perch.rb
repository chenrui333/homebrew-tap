class Perch < Formula
  desc "Terminal social client for Mastodon and Bluesky"
  homepage "https://perch.ricardodantas.me/"
  url "https://github.com/ricardodantas/perch/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "8e1b2d6dfbd324485996ab9b3c35b035fd0443e8d5608d447b947c53364ff48f"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "353129267f25edc043ce9d20c9e72f5812030d6d6051c4fe8650c50301ada380"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0823158348d6d4d4eee04b6a41f6e615fbdb74e39f63a168e48e6943062f998"
    sha256 cellar: :any,                 arm64_linux:   "e975d95b061cfc4c17ce5121aa6fe767bb1f15edd8f71145587c5aa7fe45ffba"
    sha256 cellar: :any,                 x86_64_linux:  "9af3646169a43dd4777d8394912ac00782539088ae29a328c63ad28f5b53c31e"
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
    assert_match version.to_s, shell_output("HOME=#{testpath} #{bin}/perch --version")
    assert_match "No accounts configured.", shell_output("HOME=#{testpath} #{bin}/perch accounts")
  end
end
