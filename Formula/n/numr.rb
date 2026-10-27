class Numr < Formula
  desc "Natural language calculator with a terminal UI and command-line interface"
  homepage "https://github.com/nasedkinpv/numr"
  url "https://github.com/nasedkinpv/numr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "64a9549457d89ece3a20f118a453f4e7f704e2a9f8668a1d4dab77496d8e6988"
  license "MIT"
  head "https://github.com/nasedkinpv/numr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1029d765b8af4d5780f20aaa98dd2a2a984ea3c767dfecd8a63f7a7bc7ee794"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae6dba167cea7d220d47fc8ff1a7cb6fdc371cf6bf431a4bfcaa857257d4c54f"
    sha256 cellar: :any,                 arm64_linux:   "9c53766aa62c89959c1c836e5727c6e545b4e748ffedc4ff847f029e31a3646b"
    sha256 cellar: :any,                 x86_64_linux:  "fd31d26d027ca448476fc7ed4a3a56c01815569a017e4b29d32b2703b2199f8f"
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
