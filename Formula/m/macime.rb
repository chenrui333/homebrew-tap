class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "db127614084603aebcdc569194963b76ba10d843510aa698f1ab4f1c5ed752ed"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "618c69372eff097e45ee922dee729a57ee24b4ccd99711a17fdc3db3938cd20e"
    sha256                               arm64_sequoia: "1027c4905ac3612369ae8ee0288e159ce7d14fbd5782ad6a37fc8abc9f6bf10a"
    sha256                               arm64_sonoma:  "a7935a80dd4747bf21af5081515faddefbeff63425e6d1b1fd3f7c9ec2f079c4"
    sha256 cellar: :any_skip_relocation, sequoia:       "82a4ec9c9c6d2a769e58d15821aa25fa8ec17808da52221ea00ee11108bab8d8"
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
