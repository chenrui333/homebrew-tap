class Netwatch < Formula
  desc "Real time network diagnostics in your terminal"
  homepage "https://github.com/matthart1983/netwatch"
  url "https://github.com/matthart1983/netwatch/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "3cf1616c734b51864f16d2672c3f53a983af9055a58a153584ad4ab98cdb55ec"
  license "MIT"
  head "https://github.com/matthart1983/netwatch.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6904cf0b47e2e1601f4879ff4ea5f152c3389554f0514a3c028d5503b1a80eae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5945fe395ec0a92b462a8feb52cc8f68ed028cd81d95842f9b810638202805b7"
    sha256 cellar: :any,                 arm64_linux:   "b0dc0cef1458394937e6dbecd83d5d3eca1141f4ae74b7ff2f99fd57e02d7493"
    sha256 cellar: :any,                 x86_64_linux:  "40017b9b8be5a225ae54aecafa839b7c0310f5ab0ea8b4613d126450c47379fd"
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
