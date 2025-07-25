# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.3.tar.gz"
  sha256 "159bd8cd2588ed44af7f9bc2a4f72c9a70a25d7c30aa6eb289b294a7f4ec0049"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fea568ac4852909c41e3e852b3f3a7fd44f991e1017085d9f84025727370045d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f7177571aef22df2b65d9c3481b35ffcb84f7db79ad0c22cf6116938bf13fd3"
    sha256 cellar: :any_skip_relocation, ventura:       "e947fef7eaf077f2a0b3b0210a8b8314fd9c1f9bb4566f640c304e1e73d791bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "302075662304f8e7dd96eaa90e345dd56172ad2fb4ab90df288f4502915c1086"
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
