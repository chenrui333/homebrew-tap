class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.15.8.tar.gz"
  sha256 "6f88ce9f900234e1bfb56e9369a8c041d149d90b02176a29ec71739a970ec3e8"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "netwatch", shell_output("#{bin}/netwatch --help 2>&1")
  end
end
