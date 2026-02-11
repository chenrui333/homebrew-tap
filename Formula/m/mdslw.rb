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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7716260e05f1e8416b2257dca9f3aa1c7f454c23731ead76e57043cc06c65c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8209ba428af103e3232b161a151200e096f1429f514ee233c185291cf0563329"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338c25ade0c0dded0ddfdabe47c2c58e2282c624086a5c8f3fbf99e8b4d01fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05bec2d44e80d8f8229c06409fa10ce8a43b8e75e4a9be6b9fc5b1a43a20116c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4edc5c3bc9056f9d2eea49eda8b8ffb4edadd2ac7fe10914ea8a7e600124c2d0"
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
