class Numr < Formula
  desc "Natural language calculator with a terminal UI and command-line interface"
  homepage "https://github.com/nasedkinpv/numr"
  url "https://github.com/nasedkinpv/numr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7b411612012eefb3992f2e76f69cdde44e2ada003ba8aebe6a9df76c23276335"
  license "MIT"
  head "https://github.com/nasedkinpv/numr.git", branch: "master"

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
