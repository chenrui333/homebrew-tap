# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "672aec81a84ff473861908803ea2b14fa5a48b1df404ef616bc03ffaa4d1a8b3"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d83638abe2aa1eade4fce724bb33f52f79e8a84638e3896172aa68fde4cb0a1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13d4a37d9596cbdd7f4ccb4b5cba413d07337c48aabae4d9f56416c85fcade7a"
    sha256 cellar: :any_skip_relocation, ventura:       "86b35ed0d513903d9e346e55e366f0387fadd11acfea2fc4227ad3c397c93d11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4283ab12dd8773326b35d8d12fdb1fab41e85ea7d6f36ebc3f823d2cc78b315"
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
