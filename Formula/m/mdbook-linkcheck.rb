class MdbookLinkcheck < Formula
  desc "Backend for `mdbook` which will check your links for you"
  homepage "https://github.com/Michael-F-Bryan/mdbook-linkcheck"
  url "https://github.com/Michael-F-Bryan/mdbook-linkcheck/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "3194243acf12383bd328a9440ab1ae304e9ba244d3bd7f85f1c23b0745c4847a"
  license "MIT"

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
