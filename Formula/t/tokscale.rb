class Tokscale < Formula
  desc "CLI and TUI for AI token usage analytics"
  homepage "https://github.com/junhoyeo/tokscale"
  url "https://github.com/junhoyeo/tokscale/archive/refs/tags/v4.20.1.tar.gz"
  sha256 "6a198043f7b8ebcfbcbfb5e45f0b7c477125c7300fcc827b5505de2621effbe8"
  license "MIT"
  head "https://github.com/junhoyeo/tokscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "584dba001f2ac460f2e5bb32842cec0238aed4d0e482ab7de81210baf3fe6fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0af5db5715f382c4d644f6a9577144439feba997de16609f6da7e9f0b557667"
    sha256 cellar: :any,                 arm64_linux:   "2d56958bfb0840cbe6df80ec0b43a9ad7efeedd87e30dce83019f709559ab683"
    sha256 cellar: :any,                 x86_64_linux:  "8430aa5ea0d62134107907a1196f8600f0898c71f3cda34c8a40b34fc9da17f5"
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
