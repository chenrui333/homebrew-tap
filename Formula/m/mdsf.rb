# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "9d65d6579af0de57d1e50ab1cd0a5516ddbed9f82c065bc70c466b290a777f45"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e71d4f32798a359fad7180e1847a09f0e660da79f9bd09bbe808d79096cdfc55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a9863b820a460c3d9d02edce83b8454f5c4cfbd60dd7a6eb5a61b427acef822c"
    sha256 cellar: :any_skip_relocation, ventura:       "b08946baa1dbc5d46521b6404c8d20917987f69c9afa0187fbb592a771aec300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea2e94b09ce6b2d2f4a2760644f6766ec8412d12f6e3c908ff8d80676af0967c"
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
