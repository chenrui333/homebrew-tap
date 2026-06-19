# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.17.2.tar.gz"
  sha256 "e290f36a321da01f0135f37e2c98ff95e0317c1a024b074c5320ac15fe11798c"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f7df0525854e984548b7116f59f5d5e8dd3509adf3e97782fe7dd051e16ceb06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62af5458fd7765dc8fbe0390050a1c0c26cc4c7815d5f3aca9f3f8dcc83181de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e93958c89bca84fca5b2b71b7ca88aa213b229e477b18155d79ac24d04fd4ae2"
    sha256 cellar: :any,                 arm64_linux:   "3503fcc922f72d9b3ea9b8207a61b1968942789ccc3021bd05657a293377773c"
    sha256 cellar: :any,                 x86_64_linux:  "a1df65c1ebb4d97ca38476ac3d4e50c2597d0595e78f81be37743846e07bcc43"
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
