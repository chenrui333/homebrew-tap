class Sdrtop < Formula
  desc "Terminal spectrum monitor for software-defined radios"
  homepage "https://github.com/musithang/sdrtop"
  url "https://github.com/musithang/sdrtop/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f31177c5088cd0667029a4b99b9797ebbdf72ed7f63438b7ad084df0d232b333"
  license "GPL-3.0-or-later"
  head "https://github.com/musithang/sdrtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "69b88adfe3f99edab49361f5273b86afdb8a312681abae5b40967d31fccc5912"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "970fb7c596dedd0e1df3ae3d39d31e4af5f374f8fde9bb21d4ac86658444c288"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff1f6e648d0b95507458c2fc282225b1a04d75932abfcf2b569669bd252bead4"
    sha256 cellar: :any,                 arm64_linux:   "3435c97b2ca99d87ca6f134cf0d3865342e667993b1b647be7078a401ea5a49e"
    sha256 cellar: :any,                 x86_64_linux:  "979ce72231c4553e3d2e393c7d5d0b2d4bc5868d2c1f3f5949a68fc3ad318723"
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
