class Sdrtop < Formula
  desc "Terminal spectrum monitor for software-defined radios"
  homepage "https://github.com/musithang/sdrtop"
  url "https://github.com/musithang/sdrtop/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "f31177c5088cd0667029a4b99b9797ebbdf72ed7f63438b7ad084df0d232b333"
  license "GPL-3.0-or-later"
  head "https://github.com/musithang/sdrtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8213d4a05cdee9bc62a46e888f94b2a5b69153cd6421e779cdca0f38bbc16044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7059666b00280f9dfe8c158d062c437d3e7c9612b966848f84fca0d6d7aa31db"
    sha256 cellar: :any,                 arm64_linux:   "10647ec78d0d99632ff27bd1f65a7c2ec491e69508ac96e1667b2c222b8f47e9"
    sha256 cellar: :any,                 x86_64_linux:  "fcbe65cf60bf91615538884b6db62b17d5a36f7cea72bf049c1e97e4dd8b29e0"
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
