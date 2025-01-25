class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "d2177c609dc77d8e79f6c051080b28c3fc718e6b9155ddc19d5a7e997d5c063e"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  bottle do
    root_url "https://github.com/chenrui333/homebrew-tap/releases/download/tun2proxy-0.6.6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a1b4d27852a5df141956a636328c677f3a146ee3512ef548596a11c1dc3b84a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b63fec299923cd02be0c23d4c6a4348e0ac086dc0e53d2e5ca8c4247f9cf1ce5"
    sha256 cellar: :any_skip_relocation, ventura:       "f54b08f737b0930c1efdd915a10fa07842fd721282fd313fc5772f9d4005aec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99cd652463cccdc140d08d009b4a7ba496a5909a70bd5a0a62f5292a9d310414"
  end

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
