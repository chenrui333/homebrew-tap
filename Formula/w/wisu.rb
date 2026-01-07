class Wisu < Formula
  desc "Fast, minimalist directory tree viewer, written in Rust"
  homepage "https://github.com/sh1zen/wisu"
  url "https://github.com/sh1zen/wisu/archive/refs/tags/v0.1.4.tar.gz"
  sha256 "4e638701b312987cb9af6cde412bf7fc15d80ae42d234de7fd6ca648958557fa"
  license "Apache-2.0"
  head "https://github.com/sh1zen/wisu.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0e10a829cc771ed83d4af111ebc202a93d5d9a0465fdb4c2439623ee793f5be9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0914ce7925b0543f6d623435eddbcaf3afe5a7c54b477a02adee6b4727b6c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d8841d8c7120d36d7963580834893b5313a6c168954945faa4b2340dda3e787d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8784fcf1d8b891b55757bc13477191e5e1ddd9aea5efcdf14326edba003cd288"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c7f144c087429687c4b5059bb3b7e4e4ab592ba5ee58c805a2993ca49c1557"
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
