class Macime < Formula
  desc "Blazingly fast IME switcher for macOS"
  homepage "https://github.com/riodelphino/macime"
  url "https://github.com/riodelphino/macime/archive/refs/tags/v4.4.2.tar.gz"
  sha256 "f9257fe9ac84a9650533645290f99e3d7e7d928de9a88afa280037e779f84794"
  license "MIT"
  head "https://github.com/riodelphino/macime.git", branch: "4.x"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "9371d3ad5f1a7375db5eee20a4f8f2c599b48eba40d28b7e3fc22e8970229cdf"
    sha256                               arm64_sequoia: "5db4dc4fee0d7335877895ef2eeece57caecd22d366fc660d07b6bd70b2d45d7"
    sha256                               arm64_sonoma:  "ce880e8b1ebb36174f861cc38f6b097cc6a85713a094ce2c6d58e39d1a1cff71"
    sha256 cellar: :any_skip_relocation, sequoia:       "473b7599c43a639c85b6bf01302ace4c6d95350e73189115f0f6762069f7f4bd"
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
