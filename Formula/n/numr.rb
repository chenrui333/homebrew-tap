class Numr < Formula
  desc "Natural language calculator with a terminal UI and command-line interface"
  homepage "https://github.com/nasedkinpv/numr"
  url "https://github.com/nasedkinpv/numr/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "f65e293697e971cf77978f22d62617b58894f621b9a5811cf983ed3976a01629"
  license "MIT"
  head "https://github.com/nasedkinpv/numr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c537238e5098a3e1c2335b3dafe867cc54c1f686b71fca513b09735948d647d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "906339544431eb88bc090fdf576ce19bbe4bdc783b2aca63c18afdd7fc7edbb8"
    sha256 cellar: :any,                 arm64_linux:   "9923f5a766ec5b453f5550d58803f2a5e21a7d7479cc11e401c5047db009a009"
    sha256 cellar: :any,                 x86_64_linux:  "9854a0c70b73ee88834cabff260620324425c14fd1067cc4e12891c5c52ad8fd"
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
