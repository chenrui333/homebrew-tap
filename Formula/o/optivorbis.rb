class Optivorbis < Formula
  desc "Lossless, format-preserving, two-pass optimization and repair of Vorbis data"
  homepage "https://optivorbis.github.io/OptiVorbis"
  url "https://github.com/OptiVorbis/OptiVorbis/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f1069b35fa24c9b73abb9a28859b84ad0accf968b8892b7a7825decc6c316cd3"
  license "AGPL-3.0-only"
  head "https://github.com/OptiVorbis/OptiVorbis.git", branch: "master"

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
