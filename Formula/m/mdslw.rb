# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.15.0.tar.gz"
  sha256 "9f1dd6e9a395edf381e0329b8c8c77f0221967f8c08059afec9ee9a5572afbf6"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b8f0f4bea50e64f1caaee1426738129d8f4fd4bfa3c33ae3025b07b7d417dde"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01c2adf47dc0faf3da697f4cdcfef8aa48faeb5874c22c327816e03e58d1898f"
    sha256 cellar: :any_skip_relocation, ventura:       "0d122247fbdf064c3a45598bf21233154e69b56946cb54272ebc33913aa296c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b3fc3c40c9cac5bb49beceddc03e906e26045c28ad5f38817830d2a15855b6f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdslw --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Title

      This is a test markdown file.

      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    system bin/"mdslw", "test.md"
    expected_content = <<~MARKDOWN
      # Title

      This is a test markdown file.

      ```python
      print( "Hello, World!" )
      ```
    MARKDOWN

    assert_equal expected_content, (testpath/"test.md").read
  end
end
