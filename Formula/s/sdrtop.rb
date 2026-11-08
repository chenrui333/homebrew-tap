class Sdrtop < Formula
  desc "Terminal spectrum monitor for software-defined radios"
  homepage "https://github.com/musithang/sdrtop"
  url "https://github.com/musithang/sdrtop/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "9b2519b85c8050d801ec33eb8d516fdaf54ec367c3d54d414127c2d1e0f2444f"
  license "GPL-3.0-or-later"
  head "https://github.com/musithang/sdrtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "149316426f612d121f3b0c0d3bc6d88934bb3daa54efe31b546a49f4ab0171d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e402cb96fcead6ce1087345e51b57dcda275f5235945ebfce519fb44e343f219"
    sha256 cellar: :any,                 arm64_linux:   "a948633f3d34d0f61870dae6478f41e70cf46549b7e0877ce391b26abdb50ca8"
    sha256 cellar: :any,                 x86_64_linux:  "e4558c42f7815d6563f0ac18ec3d050c4df381acfbdf17393b5e7eb68eee5e3f"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
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
