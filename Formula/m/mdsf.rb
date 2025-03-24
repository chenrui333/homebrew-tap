# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "25b62dcc34bf10b06bc1802b750c329ce9ef34855a062809e2682557bec0a7bd"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7b17f614d579ce4d9b324bb3485e9e2968284b484835ce4084758196ea4f1c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe50a3c7878025c62cce14abfdd6952f37e220c2eeaeb099ca2bcec59f397cf1"
    sha256 cellar: :any_skip_relocation, ventura:       "38e21bb6273ecdb3c18e1bf2e0cb21266b348157bfe75678706675a52e80302e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9059d115afa89565ffdc5f451aa2c6e08fc725ccd26ebbb078d5824cc6fcbf01"
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
