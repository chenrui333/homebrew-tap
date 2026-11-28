class Sdrtop < Formula
  desc "Terminal spectrum monitor for software-defined radios"
  homepage "https://github.com/musithang/sdrtop"
  url "https://github.com/musithang/sdrtop/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "fe2b00ca09452c230d8fa1d0c81dcfefef78bcc193c6542378c611402864e1e9"
  license "GPL-3.0-or-later"
  head "https://github.com/musithang/sdrtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "bd5828a561c9b56bae9a681af19b05debc7fc49fd564e5531965522927a4bf23"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "738b39b552d3d0a5439cf6513c0b86df30fd504d2e6c2800db97fed02b461373"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "103ea97d628ec552e8233df53bbbbb00b0f1f51e16261a231ed16f95430363ac"
    sha256 cellar: :any,                 arm64_linux:   "d57600b7b853db1eb895c893c7b91de8c5080c9ac3a699b702287cfc2368f126"
    sha256 cellar: :any,                 x86_64_linux:  "5c67921f63415bff202773cc06da717158fea0677de73298a7ed82d5d077fb2e"
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
