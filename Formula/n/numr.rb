class Numr < Formula
  desc "Natural language calculator with a terminal UI and command-line interface"
  homepage "https://github.com/nasedkinpv/numr"
  url "https://github.com/nasedkinpv/numr/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7b411612012eefb3992f2e76f69cdde44e2ada003ba8aebe6a9df76c23276335"
  license "MIT"
  head "https://github.com/nasedkinpv/numr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c7c5b51fb3d45cb55df6980be7c3800b280246c00b11ae3b2b5771ad8dc1a2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf227ab7ac5be288f177a205dfead6d13c8e126f52867292720870dca4f048ef"
    sha256 cellar: :any,                 arm64_linux:   "681c459b50dad656b1b8c26155ad4b6aeb6ba408fa8cc60c0af723a6a41120dc"
    sha256 cellar: :any,                 x86_64_linux:  "dbdcf53d587530dbe1a1d1a18d60319549544cfaa8367e30ac859ce65c2b0d27"
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
