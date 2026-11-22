class Tokscale < Formula
  desc "CLI and TUI for AI token usage analytics"
  homepage "https://github.com/junhoyeo/tokscale"
  url "https://github.com/junhoyeo/tokscale/archive/refs/tags/v4.23.1.tar.gz"
  sha256 "4f316d8c1af5a391b6dff4620b87850cd317b39497399a0cac42c8ca508d80c5"
  license "MIT"
  head "https://github.com/junhoyeo/tokscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "ef296ce3cd2428059c857dba7ca0e25b8fd5b3891072a40e0dbd9c009eae90f0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c8d5bd9de937a4c26e82b2b6d4948127afdb2c0b3df3c474f4c4871de900e71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ca7b3c9578dde4e88abbb889433e5b5867c167d27609dc449bad034391e4a24"
    sha256 cellar: :any,                 arm64_linux:   "35cd10aeb82cdcad8aacf720cd05762e599ab2bc6d1a8e0ee006d4baad493e05"
    sha256 cellar: :any,                 x86_64_linux:  "39163d244f3fcf863e73cfbb350d05565392a99a5a470fd354970c1d24d5fdf0"
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
