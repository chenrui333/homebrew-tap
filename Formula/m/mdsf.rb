# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "780c2b4488a7164da327661c3c690a17d279b440c076ad431e52c01bd5fa70e6"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2665ee034a60e695d9eca33a3a6d09e53f120e97adda0e78d67d028bba61c7d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "03672a76a168a38d4d07052e8c1a72a968c1ede7588f9889f6d6ac16b7d073d1"
    sha256 cellar: :any_skip_relocation, ventura:       "9d227a196ddad0a93927a2d61b5f9a60f27df2b96a6255bd8dd3622f77bd6f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2cdaf511c994edfa7ab6a308ed2935875581226cbed337afb772bad8b22c11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mdsf")

    generate_completions_from_executable(bin/"mdsf", "completions")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdsf --version")

    (testpath/"test.md").write <<~MARKDOWN
      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    system bin/"mdsf", "format", "test.md"

    expected_content = <<~MARKDOWN
      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    assert_equal expected_content, (testpath/"test.md").read
  end
end
