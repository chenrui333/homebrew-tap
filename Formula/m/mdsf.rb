# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.7.tar.gz"
  sha256 "70670c516f9e8b324651632e61ca5dbbb77d6f01f2c68f6a456be0775efd7624"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18643ca871f947bb7186bde4dd530069a5d31f8020993c5f437bd8eff8c8a13a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8737ed70ee28ff6b511f765f9b1598ea639e512c12df6c8a4a6a8f27527f7d01"
    sha256 cellar: :any_skip_relocation, ventura:       "9f82d0c06409e30e41a6ea2b0f7d2254587e91e566f021b2a535d9ca89108a0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f49a8b002ded7b5971a59fee69485130e621ec67c298db5940e065a8cb8781fd"
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
