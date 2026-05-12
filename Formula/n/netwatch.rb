class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.15.8.tar.gz"
  sha256 "79f7daac42c27712ebdfc9aae735605eca8d6d9b54ee704b17534982a9baed22"
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
