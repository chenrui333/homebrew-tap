class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "d2177c609dc77d8e79f6c051080b28c3fc718e6b9155ddc19d5a7e997d5c063e"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")

    output = shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1")
    assert_match "Operation not permitted (os error 1)", output
  end
end
