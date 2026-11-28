class Sdrtop < Formula
  desc "Terminal spectrum monitor for software-defined radios"
  homepage "https://github.com/musithang/sdrtop"
  url "https://github.com/musithang/sdrtop/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "fe2b00ca09452c230d8fa1d0c81dcfefef78bcc193c6542378c611402864e1e9"
  license "GPL-3.0-or-later"
  head "https://github.com/musithang/sdrtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "b2464da451b0ada7ca38aef8fbc3ff421493f45213e77528f5d442f4b18d5fda"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2bd7eeffa13abf36718f0916d95f56e4621c584e931809c8d4f71e36eac7df9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc16f477631ca81f8b97c63f19245734955bba50db0310b8a584fb40e0f43c8"
    sha256 cellar: :any,                 arm64_linux:   "ad98741b590845ba49a028a60cd8fc95deaaaf6f32e946c8f2ebb1654cc5ad3f"
    sha256 cellar: :any,                 x86_64_linux:  "5c00682614b509acd62ddf85f67106f982d80152abb98895a32ed694c2e9a9fb"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/sdrtop")
    man1.install "target/man/sdrtop.1"
  end

  def caveats
    <<~EOS
      Native SDR backends require the runtime library for your radio.
      Install hackrf, librtlsdr, airspy, airspyhf, or soapysdr as appropriate.
      SoapySDR also needs a driver module. tinySA needs no native SDR library.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sdrtop --version")
    output = shell_output("#{bin}/sdrtop --device invalid 2>&1", 1)
    assert_match "Unknown --device 'invalid'", output
  end
end
