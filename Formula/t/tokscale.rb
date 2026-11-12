class Tokscale < Formula
  desc "CLI and TUI for AI token usage analytics"
  homepage "https://github.com/junhoyeo/tokscale"
  url "https://github.com/junhoyeo/tokscale/archive/refs/tags/v4.22.0.tar.gz"
  sha256 "d2281968bf5cf68d394376cb9a8a320d72001e2448f7b52169f69232438bada8"
  license "MIT"
  head "https://github.com/junhoyeo/tokscale.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9280554b7c0445ea677d241f017df180c45697ca261db5bc9972755449979fd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c028bdf99e741ad779bdc0093a20b052fa543c358e2a783fa8b2ac9865bc4c62"
    sha256 cellar: :any,                 arm64_linux:   "e9e970eeaefce7c08d11b1e37e4809595bd371bcdc0dde12bac1b60b738fe35c"
    sha256 cellar: :any,                 x86_64_linux:  "f5c1ee92010f5eb0a113660ef2477347dc03e5324b165fc9a3829d73091d6463"
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
