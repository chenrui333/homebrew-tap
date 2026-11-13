class Tokscale < Formula
  desc "CLI and TUI for AI token usage analytics"
  homepage "https://github.com/junhoyeo/tokscale"
  url "https://github.com/junhoyeo/tokscale/archive/refs/tags/v4.22.1.tar.gz"
  sha256 "4ffd33e1643e1c553ad6e390d3b4e5e15f4fd61269c562a407cf0b53b56e164a"
  license "MIT"
  head "https://github.com/junhoyeo/tokscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b016d8cee6fbfec111aa28ac8ca3a8c4727b8f0cc6ad2af1b79e506317e3a5dd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0448d9cd83a6aab393fc3c6dc51c9494cedbab2fa227dfbe2896488e01027978"
    sha256 cellar: :any,                 arm64_linux:   "f2664e9a5cccfa948975c64eb1f35f32b3677dd6256e0dc6681b366ed63e88d0"
    sha256 cellar: :any,                 x86_64_linux:  "267e40e5d93c7573279c22203453bc0aa18ebc8a8eabf62a300ec4cb913492eb"
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
