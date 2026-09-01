class Optivorbis < Formula
  desc "Lossless, format-preserving, two-pass optimization and repair of Vorbis data"
  homepage "https://optivorbis.github.io/OptiVorbis"
  url "https://github.com/OptiVorbis/OptiVorbis/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "3f55f676239847b8cff72bbc35f99c3f0b8dfea5de9a3be3e6ca00fb55f06d60"
  license "AGPL-3.0-only"
  head "https://github.com/OptiVorbis/OptiVorbis.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b83ac68b5e7bc8b36e2969f456aa8cd8a0cbb0f372bac3c287398b7680d831e0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d8bbcf6f57ef51774e353ccff500cdccbe259935857ada1ccbc372a94f44f6d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3bfd36e0ebf79a90da2774017a36749184842532b58ca294a5091c4dcd4adaa3"
    sha256 cellar: :any,                 arm64_linux:   "c452be90714bf278d4c3e7f4ae0bbc2ccef2a718777f8f41a992645841861148"
    sha256 cellar: :any,                 x86_64_linux:  "045c0bffd2fb05758a362082b485c8526add0409740c6fd92c064ad5081db552"
  end

  depends_on "rust" => :build

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
