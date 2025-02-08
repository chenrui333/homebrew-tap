class MdbookLinkcheck < Formula
  desc "Backend for `mdbook` which will check your links for you"
  homepage "https://github.com/Michael-F-Bryan/mdbook-linkcheck"
  url "https://github.com/Michael-F-Bryan/mdbook-linkcheck/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "3194243acf12383bd328a9440ab1ae304e9ba244d3bd7f85f1c23b0745c4847a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "868df859c381ad2bd641c57d04115fe3d9bb94e83860789549e5a22bbe5e3e50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58c998c81ff24783c0fbc51d97857e1a42d88fc975a2a54779edaec31ee8fac4"
    sha256 cellar: :any_skip_relocation, ventura:       "4646eb2abc72942cc985586944a366a91c1308b40379091d0e833bc995c7e3da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c74ee710f61f9116b93b89d29651e7d58270788819198202a1cc7ebb44efd972"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "mdbook"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdbook-linkcheck --version")

    (testpath/"book.toml").write <<~TOML
      [book]
      title = "Hello, world!"
      authors = ["brewtest"]

      [output.html]
      [output.linkcheck]
    TOML

    (testpath/"src/SUMMARY.md").write <<~MARKDOWN
      # Summary

      This is a test book.
    MARKDOWN

    system "mdbook", "build"
  end
end
