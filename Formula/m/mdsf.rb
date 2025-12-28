# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "77742b8c50ab87a99fe1dba121243fa1283addf1944cc6fa08be0b9838d13d99"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ec1adf0cb4e61db5451cbfc8ed71b82c5643ba758532de75a0f83e2438fd38b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62cf93f8103a926ee84e280bf31c7e6ad8dd9b5b1add121d51c63d8a7b8471fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "281c0c64e079e0a0c9488eeeae8683386903bdaa58247305ba39fdde5f26afb6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a54e805cfc0ca2b8c3f0faa0e6961ea0eb6e1413f73473275608e86b7f57685"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76b58cbc250eafec231b49de01b132579d4c0e19d8eead75ad5c273d3f176dff"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "mdsf")

    generate_completions_from_executable(bin/"mdsf", shell_parameter_format: :clap)
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
