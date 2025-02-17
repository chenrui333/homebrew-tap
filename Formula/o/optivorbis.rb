class Optivorbis < Formula
  desc "Lossless, format-preserving, two-pass optimization and repair of Vorbis data"
  homepage "https://optivorbis.github.io/OptiVorbis"
  url "https://github.com/OptiVorbis/OptiVorbis/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "f1069b35fa24c9b73abb9a28859b84ad0accf968b8892b7a7825decc6c316cd3"
  license "AGPL-3.0-only"
  head "https://github.com/OptiVorbis/OptiVorbis.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65cc8e05adedf64510ef2e5475dd0c2f7d091f7eebf8792100520686d693aa01"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3df0a7045b7f99b68ac3a17865e29d117edada5d5aa39a6b1e044243bd868450"
    sha256 cellar: :any_skip_relocation, ventura:       "cae04dcdce0589fae6a93dc9d72d1bb8355fd0f46ae63f15cf64693c839ee36c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3a6664d6c4ee84b6d6cfc9fee194c6c8abef48e1994ba2ebe1b75e018512f5c"
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
