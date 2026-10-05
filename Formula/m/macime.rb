class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "46b6ba42296c76954d3017bb7b7fc32cee0cca0fa991c383024ebe3246adf696"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6c3fd30db75856efdef23e2e3fe8affd506e366ca86eff6db3a57aafbf842842"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2f7860b2c3fc57198c4e631765ba20363b41f83e7d4dc5a049de3a5a304b16d"
  end

  depends_on :macos

  deny_network_access!

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/macime", ".build/release/macimed"
  end

  service do
    run [opt_bin/"macimed"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macime --version")
    assert_match version.to_s, shell_output("#{bin}/macimed --version")
    assert_match "Invalid log level", shell_output("#{bin}/macimed --log-level nope 2>&1", 1)
  end
end
