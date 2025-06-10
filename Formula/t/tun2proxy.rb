class Tun2proxy < Formula
  desc "Tunnel (TUN) interface for SOCKS and HTTP proxies"
  homepage "https://github.com/tun2proxy/tun2proxy"
  url "https://github.com/tun2proxy/tun2proxy/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "792b1267d47380289745dca1300d2e42a1c6f3f33af475a54031b0b56c4ff61c"
  license "MIT"
  head "https://github.com/tun2proxy/tun2proxy.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca9ba1dbcb659f2b7a469be79fa75c933c0c72f00189abe540197fe78be49289"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62e6d40aa874d20c9d118fa11f23ec6a98c0562accec2e2ad328181e53280d7f"
    sha256 cellar: :any_skip_relocation, ventura:       "24861e302e90e4a8c1b2138674ddfe1e0691f96cb185eef6e51fdf6811e75cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e108ae33a79f84138a53075f418aedd613dea27a67ce8fbb421344866f6fbf79"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tun2proxy-bin --version")
    output = shell_output("#{bin}/tun2proxy-bin --proxy socks5://127.0.0.1:1080 --tun utun4 2>&1", 1)
    assert_match "Operation not permitted (os error 1)", output
  end
end
