class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "5a3609954a847f845bac4a6a614dd439f9adc42e9c086d21a328c36cb935b314"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2aeffd9c5c7ffb7e24c1ca48fcf700b83b42a76aa6e737164eaf69e2a70a7f4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf5e741aeb5cdc3f0d10483b3bcf39aad6b901a3295a9b153fe94089039bf62f"
    sha256 cellar: :any,                 arm64_linux:   "ca4739deb45906410b1f2bd82fc135b58bb7ecfdf55f03991b917d68e96a458f"
    sha256 cellar: :any,                 x86_64_linux:  "be207efabbf6eba4d74ac453dd7985c0b7d86d5ac58a3523470eb9d7d245f4f6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    require "json"

    ENV["XDG_CONFIG_HOME"] = testpath/"config"
    (testpath/"downloads").mkpath

    assert_match version.to_s, shell_output("#{bin}/ghgrab --version")
    assert_match "saved successfully", shell_output("#{bin}/ghgrab config set path #{testpath/"downloads"}")
    assert_match "Download Path: #{testpath/"downloads"}", shell_output("#{bin}/ghgrab config list")

    payload = JSON.parse(shell_output("#{bin}/ghgrab agent tree not-a-url"))
    assert_equal false, payload["ok"]
    assert_equal "invalid_url", payload.dig("error", "code")
  end
end
