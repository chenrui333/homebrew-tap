# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "db8d6ad3e6b9f89554813da80762ccf5b608b94140141d96c656361607ed9b90"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "064588b47e1eb7a2d28acfe1a2de51255661bcd70e3e47d279e637d099a383c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "774ad9395fd55b1cba76f9f1842e979d99f6ab409fe407c1cfa66b4f5995f418"
    sha256 cellar: :any_skip_relocation, ventura:       "126732443f9e54d1a32fd9b35490d67af7f3121e135d28fa43332595f19783ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e00f7f89faa5431253684f9f268d59041f0cefbfd71ea7ae5d8453c0eeddbe73"
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
