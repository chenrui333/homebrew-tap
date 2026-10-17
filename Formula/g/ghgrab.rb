class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "7a76bcca5667d2df9d3f824f5b7c57b676f09cd3fa586083d56a2c0afdf0a09b"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d4b252b3c21ad5d7b463bec4dcd882f7f32f1cba5ec4c88e26c7e38d633413f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0467fcbee918214a8750f0a2550d97d53023d065a7cbdeceb115d61cb26a3a2"
    sha256 cellar: :any,                 arm64_linux:   "1c24b77a5c783aac80850674add7d4e6d0ba9353fd402b941ca273168667d9f9"
    sha256 cellar: :any,                 x86_64_linux:  "a5b0e925598f04eb745de2d89696c02a88b2fb492cd0b916584f27a49c55b85d"
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
