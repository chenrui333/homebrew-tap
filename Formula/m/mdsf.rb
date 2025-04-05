# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.8.5.tar.gz"
  sha256 "214e6f1fe3808405d9935a4ca19990c55fb65ea0ca0d0c090f6e1d0956c08086"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "986d485461252f6c214d47bfd9022adc280331ec66ccce6e5fbe79066fd038b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "048c64b2911b42837cfbfbaaf41ab90b5b808b02b2ea8c8aeeecf982cf3a393c"
    sha256 cellar: :any_skip_relocation, ventura:       "b33a2fa79cc04aa4ae2825fae12c92a90db95fcec16ff6ea583b30f2cfbe1d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e17588dd634905d127126aed9563aeebe0a3d77517c1923e22434b55d68b32b8"
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
