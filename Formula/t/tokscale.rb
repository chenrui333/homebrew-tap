class Tokscale < Formula
  desc "CLI and TUI for AI token usage analytics"
  homepage "https://github.com/junhoyeo/tokscale"
  url "https://github.com/junhoyeo/tokscale/archive/refs/tags/v4.22.1.tar.gz"
  sha256 "4ffd33e1643e1c553ad6e390d3b4e5e15f4fd61269c562a407cf0b53b56e164a"
  license "MIT"
  head "https://github.com/junhoyeo/tokscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac274741c78fc9393c0eb4dbc7bcab204daf387f2bf9a95153007355bd2f730f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b849b5e86304fdd66d85d4c08cbc8dd5da3131426968f17342f18d62dde2657b"
    sha256 cellar: :any,                 arm64_linux:   "9c050c4b90d3090fc6ae3d7accf656ae15cca1f1a9758c5f53c12397340b9020"
    sha256 cellar: :any,                 x86_64_linux:  "5a7ceac68b230d021ef1d89a549f8d63a72257dc54e88e0b12806a5165277c2e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  # Cargo fetches the locked crate graph during the source build.
  allow_network_access! :build

  def install
    ENV["OPENSSL_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "crates/tokscale-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tokscale --version")
    ENV["XDG_DATA_HOME"] = testpath/"share"
    ENV["TOKSCALE_CONFIG_DIR"] = testpath/"config"
    ENV["TOKSCALE_PRICING_CACHE_ONLY"] = "1"
    (testpath/"share/opencode/storage/message/session1/msg.json").write <<~JSON
      {
        "id": "homebrew-message",
        "sessionID": "session1",
        "role": "assistant",
        "modelID": "claude-sonnet-4-20250514",
        "providerID": "anthropic",
        "cost": 0.05,
        "tokens": {"input": 1000, "output": 500, "reasoning": 0, "cache": {"read": 200, "write": 50}},
        "time": {"created": 1718452800000, "completed": 1718452803500}
      }
    JSON
    output = shell_output("#{bin}/tokscale models --json --client opencode --no-spinner")
    report = JSON.parse(output)
    assert_equal 1000, report.fetch("totalInput")
    assert_equal 500, report.fetch("totalOutput")
    assert_equal 1, report.fetch("totalMessages")
  end
end
