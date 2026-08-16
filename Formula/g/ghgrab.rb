class Ghgrab < Formula
  desc "TUI for searching and downloading files from GitHub repositories"
  homepage "https://github.com/abhixdd/ghgrab"
  url "https://github.com/abhixdd/ghgrab/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "a30a9b812cad290ded124924b3443073e80dcabc4fe479ca98fa01d942b69a41"
  license "MIT"
  head "https://github.com/abhixdd/ghgrab.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85dad0b2479f7e215e858e1b61a0ee866e0f7073a9b2832232de0c5d619016bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d25a669cdbf21a8c0c7c3091dd5b9ae1ec989d1ba08ca72ec9bb762c5f274de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e18c4b29df9fea33137f40f8f2f8a2f066f498230346abae7656bfa1f3a7837"
    sha256 cellar: :any,                 arm64_linux:   "d49b0e41da85e6eb0a7c10a57460450d22659cbb92e599366053a3c8b6d1e875"
    sha256 cellar: :any,                 x86_64_linux:  "92fde7e7c8e7c6a783d9bcf7bb13ff69e60327e738c11b46950858b259830439"
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
