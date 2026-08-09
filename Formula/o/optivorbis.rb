class Optivorbis < Formula
  desc "Lossless, format-preserving, two-pass optimization and repair of Vorbis data"
  homepage "https://optivorbis.github.io/OptiVorbis"
  url "https://github.com/OptiVorbis/OptiVorbis/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "2416bf529e281040c052e40c57836385a935f2ebfd79eb6430c77cad244182d4"
  license "AGPL-3.0-only"
  head "https://github.com/OptiVorbis/OptiVorbis.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8e8f125e96993b3a71081f8c59ba854ce9a1794b841df7e085ebcc6028c72092"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d0440450a8d6275896c8c29cf043987d88213e73c5ee57777ea3b2914fdade"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3cdbcc3500cf2080ad1774acf0bc97496e6ad3ca8c613cc8c4d710cc2d22dcb1"
    sha256 cellar: :any,                 arm64_linux:   "a0460047d8f8f37c293d3fac4f3ce5a008a19a824095db92b14709249d5ac6c3"
    sha256 cellar: :any,                 x86_64_linux:  "35956db00e3d22d250b5c1abc5a46e98fd6c7b793e97123104df4268f9e375ce"
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
