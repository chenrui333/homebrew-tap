class Wisu < Formula
  desc "Fast, minimalist directory tree viewer, written in Rust"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "4e638701b312987cb9af6cde412bf7fc15d80ae42d234de7fd6ca648958557fa"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c405593b47a22b32a908e94a6772370c746b1f4df4aa046042bf55d90fd119c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "944d81038ee5fed57d10a0a316ae5739bc8edc1fd09869071efe84038fbc770a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4c09a4164f2a5fc26040e948881517de207459bbf779e5be297d8572d2ed78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2b3b9ae3dec228e5baddad206c6f8dca36666dc6e0f37cb5d32d248cee2a6abb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "741d365a048f314fe01eabc21aba6a900cfeea940a00691a1f5a426541b9b438"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wisu --version")
    system bin/"wisu", "--info", "--stats"
  end
end
