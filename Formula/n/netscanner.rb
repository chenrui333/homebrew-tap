class Netscanner < Formula
  desc "Network scanner with features like WiFi scanning, packetdump and more"
  homepage "https://github.com/Chleba/netscanner"
  url "https://github.com/Chleba/netscanner/archive/refs/tags/v0.6.3.tar.gz"
  sha256 "ad2df332bb347eac96c0a5d22e9477f9a7fe4b05d565b90009cc1c3fb598b29f"
  license "MIT"
  head "https://github.com/Chleba/netscanner.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fff5ff7c63929451365347808c9bd408fc56735b79f5838e6e8a2c903aa5ee91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc0f6b4a6ea9cea9074e1ab194afafbb1b6199af98defd26e91e218720d60e09"
    sha256 cellar: :any_skip_relocation, ventura:       "9063088a83abb6929d8d90dbcc00db039806515dda9e62a2c152cd202a6f7515"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15b15ce1ba472deb6c6722394d1c05902186d991061f00ba3f07867e3bc5b523"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netscanner --version")

    # Fails in Linux CI with `No such device or address (os error 6)`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # Requires elevated privileges for network access
    assert_match "Unable to create datalink channel", shell_output("#{bin}/netscanner 2>&1")
  end
end
