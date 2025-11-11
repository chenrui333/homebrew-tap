# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "16f78a2dad97efef182bdc027b155bdce712921e0f72e7006d38a3e31682c627"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55969cf9836ae1185cac3b2a67e31c4b6a7e3992403612ad0a0bf5d453475d37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5db69cf67f2930c1550521d7947f48df7ec1f4214c4cab996e5ec068781a84df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16e6318df0aa4cfd9b7c0952d1f0ae9c3218c6933b1d08dedd9e15ebab454c3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e394ff78b6eefd0ba3c68a7890c841ec5c7867b3503f737277540ddf364aae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79a7a0caa5373622971edefa69594c48f32fb5dd9e9bc9cd96377890431a73fe"
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
