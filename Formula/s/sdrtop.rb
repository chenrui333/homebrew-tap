class Sdrtop < Formula
  desc "Terminal spectrum monitor for software-defined radios"
  homepage "https://github.com/musithang/sdrtop"
  url "https://github.com/musithang/sdrtop/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "9b2519b85c8050d801ec33eb8d516fdaf54ec367c3d54d414127c2d1e0f2444f"
  license "GPL-3.0-or-later"
  head "https://github.com/musithang/sdrtop.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0d3753fa797f8424719763cc8ac40d162880b2240ad577a952d625c0fe71c7c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "34a5ae1f06280c66aef6a88ff8491641a94a7b788bcd7b4c30c67b88ab16fc87"
    sha256 cellar: :any,                 arm64_linux:   "aa088fc380667f852dca9f9ea770efe76dcba7f1ec3e5dcbe2848eeaf3460417"
    sha256 cellar: :any,                 x86_64_linux:  "9e04936d4eceecc4c35719e1efcb0fc1c74fb7359815291deded9be210660e35"
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
