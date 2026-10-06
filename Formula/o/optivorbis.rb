class Optivorbis < Formula
  desc "Lossless, format-preserving, two-pass optimization and repair of Vorbis data"
  homepage "https://optivorbis.github.io/OptiVorbis"
  url "https://github.com/OptiVorbis/OptiVorbis/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "3f55f676239847b8cff72bbc35f99c3f0b8dfea5de9a3be3e6ca00fb55f06d60"
  license "AGPL-3.0-only"
  head "https://github.com/OptiVorbis/OptiVorbis.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c88e7be95180e56cbff5c4be02aa629c14c66004d7310b5cc593905517abfbda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e129d67db0035e413ba4bd125b8053b6ef596354f081a17fe63b7cb6aeda651"
    sha256 cellar: :any,                 arm64_linux:   "147198b7e415294e95b6528575852742a55587894b31a2390cab15933b7452c1"
    sha256 cellar: :any,                 x86_64_linux:  "9f8c29417aba5d4631a4477aaece5af82f15e36cef3b813e3d014dfc1944c8db"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "packages/optivorbis_cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/optivorbis --version")

    (testpath/"input.ogg").write "dummy ogg data"
    output = shell_output("#{bin}/optivorbis input.ogg output.ogg 2>&1", 1)
    assert_match "Ogg read error: No Ogg capture pattern found", output
  end
end
