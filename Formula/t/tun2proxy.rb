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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1eef28932e27a1efaa6578f77b6cc2ef40ee43adac972dce298cd1eb854e69c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08b2dceefcef958288c5bbb4826a5218c45c12dd17a5217891679ba2f56eca7c"
    sha256 cellar: :any_skip_relocation, ventura:       "d62f1cacfe113101b28b3df8eedcad458f97a949e81b1b13047434f0ec6b726a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b756b76646c4df4d8591a93659889eaf106b1321bf2f719fa90330b2ebf7765"
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
