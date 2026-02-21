class Polymaster < Formula
  desc "Monitor large transactions on Polymarket and Kalshi prediction markets"
  homepage "https://github.com/neur0map/polymaster"
  url "https://github.com/neur0map/polymaster/archive/95277b34c66eaa307d169cec45320ffa9f2403a0.tar.gz"
  version "0.2.0"
  sha256 "235e3078ee8a9a348d9d75389e7c6f5837c0f4dbd6b748c03b3c9b49b88f8fa7"
  license :cannot_represent
  head "https://github.com/neur0map/polymaster.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8df909db810273fb46ff2e6a22adb47575ae382a60ceb304385ea48ede0c28dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "631f3027549fa9a19edf0ad8c09aac6f7e3d9187c7e0a6f908b2550d295c4acd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2635686458b9a1aaf0abb0c73873b092e4ea2d2875016d647f88afa7c97e8abc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e431d023e3887cfa6b0c81f231e0fa7959b8a052b0e3d989d4349b3841a18c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6ba8099f84d9e4feeab5f5eba7816c609c6361d2316fec7d8efdfaf6195b60a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: ".")
  end

  test do
    ENV["HOME"] = testpath

    assert_match "Usage:", shell_output("#{bin}/wwatcher --help")
    assert_match "WHALE WATCHER STATUS", shell_output("#{bin}/wwatcher status")
  end
end
