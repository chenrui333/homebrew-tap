class Ninjabot < Formula
  desc "Fast cryptocurrency trading bot implemented in Go"
  homepage "https://rodrigo-brito.github.io/ninjabot/"
  url "https://github.com/rodrigo-brito/ninjabot/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "b5068dbb125d423956857cd0e73aa4c8df6b6720dfece9caff4dcd3c120d1685"
  license "MIT"
  head "https://github.com/rodrigo-brito/ninjabot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "004734d79c9600b692b18ebb2aa6bb5687311100b2e4ba12782d254fef85d81e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "004734d79c9600b692b18ebb2aa6bb5687311100b2e4ba12782d254fef85d81e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "21d6e37d6ade4cda4c28dbae7df95d857c37cc9eafcb99a993431a9fc1fddcab"
    sha256 cellar: :any,                 x86_64_linux:  "3624849c0803acd14217d83bdfbc07ea53b22532c5e589dd8983b39dfafa2398"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/ninjabot"
  end

  test do
    # The only subcommand downloads candles from Binance; flag validation runs before any exchange client is created.
    output = shell_output("#{bin}/ninjabot download 2>&1", 1)
    assert_match 'Required flags "pair, timeframe, output" not set', output

    output = shell_output("#{bin}/ninjabot download -p BTCUSDT -t 1h 2>&1", 1)
    assert_match 'Required flag "output" not set', output
  end
end
