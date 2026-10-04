class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.35.2.tar.gz"
  sha256 "9499c109dfb148ed5da79a9c0c6c5bc83672e7e7362af18efc31456c98528fed"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dbda16df0dc5e083f3b8338eed243dd337b7f822af2b1db4008152c9c2936ba9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "639d6a993e6ead93147175cde0a0234255ece98a0c9bcaca351414be5ea3f8c9"
    sha256 cellar: :any,                 arm64_linux:   "58dbb3fa0fa810763c94f846992939c258802bbaf1bff1cc355a1b216b6995db"
    sha256 cellar: :any,                 x86_64_linux:  "94780b2ee5664cc4f9d77eb2e82fdcb1f9952f2c6927fac2ce6ae22109eb20e5"
  end

  depends_on "rust" => :build
  uses_from_macos "libpcap"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/netwatch --version")

    output = shell_output("#{bin}/netwatch --generate-config")
    assert_match "Config written to", output
  end
end
