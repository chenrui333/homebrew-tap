class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "71b90fda5c0d605b0b10d2a3f1744828afe91f6ab3f87119a3b1ede9fa40ba76"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8db191ba4302de04e1547bbfcfd69a8831d1585e6e476c91f23da6583f8404f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "374db3063827d6cff44937aa16bab7ebce101301b57f69f8bc8f25204667e4cf"
    sha256 cellar: :any,                 arm64_linux:   "8bbb45fbca126003d2f6fdc8a832000dda37b2fd8f291b542565613c78ad2c77"
    sha256 cellar: :any,                 x86_64_linux:  "22ed938f10596586aece956237a3d3bc3f14eeffc7c54c46a53b4b2d8ac4159b"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

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
