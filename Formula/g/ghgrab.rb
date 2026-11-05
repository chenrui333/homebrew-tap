class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "1efbe3553a29a2c62d71b0a1eee18937ae2beb80f9313426bfe1a152064ff5a7"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78a96e1f4fcc1805d570d9ce631430fdc21eeec23817e18925a569dd61c3f7df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "217f5f24522fb73ed2e1fb1282e1793cafa7ab83a7df951cc9d96edd42f7975e"
    sha256 cellar: :any,                 arm64_linux:   "2eb786f75a7ed7dd1c6d14578d1915f69e13c0d918a5bca67ecfda4be9ef7690"
    sha256 cellar: :any,                 x86_64_linux:  "1a3d85d0840599e6d8456291d86f8202b03f33122249651a3d2de5519f2af2be"
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
