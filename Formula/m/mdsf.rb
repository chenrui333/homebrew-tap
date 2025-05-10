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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b382b2088baf3cff6859fe71009c84249b623968cf807f390db1384a50dcfbd1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "825962224f81dd9b42308d69aa7f3c25f4001b0be659d256cc3103533b69f663"
    sha256 cellar: :any_skip_relocation, ventura:       "c5324d2b57cffcfbfbc7b11785c5c8d9a994ef324cadb048b303bef969867eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f3f87a7f291918db286f1bce2a18d442ec340a8753ac0f574f9f92c1a2003d8"
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
