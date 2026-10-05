class MdbookLinkcheck < Formula
  desc "Backend for `mdbook` which will check your links for you"
  homepage "https://github.com/Michael-F-Bryan/mdbook-linkcheck"
  url "https://github.com/Michael-F-Bryan/mdbook-linkcheck/archive/refs/tags/v0.7.7.tar.gz"
  sha256 "3194243acf12383bd328a9440ab1ae304e9ba244d3bd7f85f1c23b0745c4847a"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9bacea62a21f3481fbf6dd5b40207292a5a05aad0c906dd3336d4cd08ed01b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea1c68d1e2591ee6b657299e18ba55f970d150044f15fe716a239c2c1279708e"
    sha256 cellar: :any,                 arm64_linux:   "11b0847a7028f446d32007e10ca412c30f095f271fe41d46521865e78d105cfa"
    sha256 cellar: :any,                 x86_64_linux:  "b1668a42258b571f5143c3543d75de5aa8e218f99f7c852babdb07980e378c52"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "mdbook"

  on_linux do
    depends_on "openssl@3"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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

      - [Chapter 1](chapter_1.md)
      - [Chapter 2](chapter_2.md)
    MARKDOWN
    (testpath/"src/chapter_1.md").write "# Chapter 1\n\nSee [chapter 2](chapter_2.md).\n"
    (testpath/"src/chapter_2.md").write "# Chapter 2\n"

    # TODO: Use `mdbook build` again when https://github.com/Michael-F-Bryan/mdbook-linkcheck/issues/96 is fixed
    # (the backend cannot parse the RenderContext sent by mdbook 0.5).
    system bin/"mdbook-linkcheck", "--standalone", "--colour", "never"

    rm testpath/"src/chapter_2.md"
    (testpath/"src/chapter_2.md").write "# Chapter 2\n\nSee [missing](missing.md).\n"
    output = shell_output("#{bin}/mdbook-linkcheck --standalone --colour never 2>&1", 1)
    assert_match "File not found: missing.md", output
  end
end
