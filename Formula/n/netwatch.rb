class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "b3096edb78aec785f5a066c17cacc640f72bc95084418268295dbeaddfd7dfa2"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0466a57dd1a25bebae6fe7fd34982a66dc6f8411c4c4d015693fdca7f1e6a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bdf6fe43793cd1c860039f2c6b8bb99c2d75b072fce6402bd9d9b41f60f2869"
    sha256 cellar: :any,                 arm64_linux:   "8f9f13261b1b67ccfb8b8bbbd94e932faaf44732b79e14a45f5be96d160da12e"
    sha256 cellar: :any,                 x86_64_linux:  "9401ddc6a7a19358735609552d6cb23732fffe69a0312d6b316805bffadae3a9"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
