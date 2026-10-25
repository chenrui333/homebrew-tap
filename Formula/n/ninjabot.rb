class Ninjabot < Formula
  desc "Fast cryptocurrency trading bot implemented in Go"
  homepage "https://rodrigo-brito.github.io/ninjabot/"
  url "https://github.com/rodrigo-brito/ninjabot/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "ebb4f8abccdcda151cc4eb18e8b1b08df857a5e71792e973a3f315c8eb1344f8"
  license "MIT"
  head "https://github.com/rodrigo-brito/ninjabot.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc247adc6ec962dacd1dd16754c1c86d25c0139073556b35a6b7864dc6acab03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc247adc6ec962dacd1dd16754c1c86d25c0139073556b35a6b7864dc6acab03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82891517daa95cd63c4e5dbdc90f150d4c672e0d47e6db1f3891e7f7ccb6b712"
    sha256 cellar: :any,                 x86_64_linux:  "d9d0af5adc9bf28ae768244852905e426bfdfdfea2e022c8b017f7f2fbf9a5d5"
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
