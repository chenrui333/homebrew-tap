class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "db127614084603aebcdc569194963b76ba10d843510aa698f1ab4f1c5ed752ed"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0bf26fb9a6af7dcdb846da1fb416f6d4c2a2bad5cf6015c031d431a4696c19c7"
    sha256                               arm64_sequoia: "6b39155bae9d6d59e62fb557a05756bd981ee8d43c6e492edd3f253926a5f95d"
    sha256                               arm64_sonoma:  "cdfa5ae4041d05ca76e57afad9daed0bf8d2e409b799a5101e504fcd70eb9419"
    sha256 cellar: :any_skip_relocation, sequoia:       "782688a18df4b2045b9cb9f3e2e0dfdf247c598f4caaa8b5b8fcc2a403087562"
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
