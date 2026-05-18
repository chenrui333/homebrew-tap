class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "bec4ebe9033a70283b2a8c8b44e47d70fbd9c33606f54af3874887bc0d3722c7"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "050032ca938e909b7421248aa3fea55b1790767b491f5285c77fc4b8da478fee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45d33cf5efe31f943c32c6fa253492c155c3d0051987f6a1021e6e1e2596d805"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95157907c4a270e24ead85103f10415c16c3f5bf69068d96aa0a6e95aed889e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9df6c4698879ef6903c99d5399b606fc9a3ba2809a3126ec7e2015218da41091"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7634d14b8c2127bef5aec1f5856058fdd012d336301d8e4baf80e000a7756569"
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
