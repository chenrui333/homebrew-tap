class Numr < Formula
  desc "Natural language calculator with a terminal UI and command-line interface"
  homepage "https://github.com/nasedkinpv/numr"
  url "https://github.com/nasedkinpv/numr/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "58f9b535234cd159044edd943e407928aefd2414a6191ae56d88c4cc19b232d9"
  license "MIT"
  head "https://github.com/nasedkinpv/numr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "337b19d8148f2c258bcc4bce9b6c7b961f500a4e3c6011aea94c058ff906eff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ee9dbf2cb2dee0bcbdeec7f21bff24977cf566d77854eb786dcd1e0277e23dd"
    sha256 cellar: :any,                 arm64_linux:   "8e98336827ecc5e78c1ad5f3420b4202f4c773b19fff0ca3c3c3d1f211d429fe"
    sha256 cellar: :any,                 x86_64_linux:  "e61ad95d6c61664e4414acbf4498ae1cdf2846a8dc2313340109a2e87f37c5e8"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/numr-tui")
    system "cargo", "install", *std_cargo_args(path: "crates/numr-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/numr --version")
    # Server mode evaluates with deterministic defaults and skips exchange-rate fetching.
    request = { jsonrpc: "2.0", method: "eval", params: { expr: "20% of 150" }, id: 1 }
    response = JSON.parse(pipe_output("#{bin}/numr-cli --server", "#{request.to_json}\n", 0))
    assert_equal "30", response.fetch("result").fetch("value")
    assert_equal 1, response.fetch("id")
  end
end
