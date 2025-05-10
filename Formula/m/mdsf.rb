# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "8a63873bcfa2585df03b91db7b70c3ace9d2d951502fead2e0a4cb54d647d44c"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "865b09ecf6219fd8fef363ca2b482f774c9a7d1a584baba75c1eff1e1ec0e542"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c3a9f357e66ead5e507876b2f4558ec1ac3dc908e6e7d37e91fc25c6c1ab1b75"
    sha256 cellar: :any_skip_relocation, ventura:       "72b49eb2b0ebf8414445c9c35f2a7d1855f34c9f4ebe931c5eea29b025c0fd5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96e68f2708f74a90d9a7d045eac7e1f493726b923c7b9d43a8cf41612669c8eb"
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
