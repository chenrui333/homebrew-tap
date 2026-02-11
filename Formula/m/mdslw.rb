# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.16.2.tar.gz"
  sha256 "9d22219266aa18eb9e7e54e73b043c3e940a5dacc7c7bd7dec0964df033d5187"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e30af1efb3f3461f48f70431edba42bd0db0dfc94ea7fbcd03c5503bea99570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "835c927511c6f60a837050f64c1345616e9eccd4b0e8da302e9b5882d41c1e95"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de17d8d8e044e3ca60b0bb7982c13ea4d90008021b71afcf62aadb1deadffb3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eae02e0cf02fa775f0a83a4c9a556e7faaf0a4f06c7b5282b77e05c4b7e091b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "587e11acc1ef3637f16c32800d3154e1f7d2871d3b7e01042f06115e51d8532b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

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
