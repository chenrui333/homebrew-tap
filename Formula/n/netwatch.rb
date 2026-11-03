class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v0.40.0.tar.gz"
  sha256 "f72a0d41530f86f81a18f719b59115fd3a995e211eadda35685f68ceba469164"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2272d4d166658328fb46f02a96a0332ab5b9ae4fc66bdc815deac70958fc629"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b410c5c3c7e052ecb1d1704de1287f6f96a229446957c757730bad6fd42d1952"
    sha256 cellar: :any,                 arm64_linux:   "990ec7c4dbf0d0028a3900d37877d6191e89d496aad7c45879501c5e5cd117d1"
    sha256 cellar: :any,                 x86_64_linux:  "76f38bf07588980b21edd9a7f227cfb6d78cb32fa2c7fbc5b4ca6ac5fdc20919"
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
