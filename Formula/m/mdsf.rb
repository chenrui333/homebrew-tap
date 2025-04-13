# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "94322950bc0132388a4dc1003012bbaab899fa9ee26cfd298cbb58fbbe6f166a"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "02bac55714395621e4af7da3ff9bdf944ce16ac56e70de75f8da18e86b025598"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e74a9080d01b2d34fc0239813801efb74f4853119d3cd4cfb4e084edb2a3dc0"
    sha256 cellar: :any_skip_relocation, ventura:       "88f7c568af45da2189a03e08ba4b1b179036a5f00857d12f0fa05ebffb6d0a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d89a2574753fd4ee16617353fbfa9bc9a13c4d5a652874c708a275d1717a804"
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
