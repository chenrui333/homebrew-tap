class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "46b6ba42296c76954d3017bb7b7fc32cee0cca0fa991c383024ebe3246adf696"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b331aa700f28a225da82ebdbfe5dc8ef43363fda5e6b5ca140c2cef095fd11b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ea753726f2f7e58b319ccdfea3d3d2b0df193f6377e9124abcbf043c83f5f37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "112f02c84acfc33f23f996b4180ead3f8d3c2547859345d0385e9649862701b0"
    sha256 cellar: :any_skip_relocation, sequoia:       "1be59f7509f84ce0f16e2463803512d57a027521b9fc3f19dacafb7babe34bf9"
  end

  depends_on :macos

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
