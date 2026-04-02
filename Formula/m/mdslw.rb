# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.17.1.tar.gz"
  sha256 "4dadf34036002909b1c2e547facb88b37a3a3ac0cc102d9a924fcc0161db1637"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a53628a8d4945059beef37cb6a8cf3d9357805360b68d36c8244b7d14ad97d29"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "087c59f4febb4c5d080337ceba8519163b6f4bcb6d7f19d25efef0c00d7df800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "37b224cf788bd310805624c886be3f4815546bd75497fbf4123d98719110b68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eefdf4b2b4cb14b96b19572556b64f936f09df9824accb3d71bbd74ed0a1eb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8f7d9b781f60e1e06549170c8ae0d468021ad552561914eddbbf88d33f337a5"
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
