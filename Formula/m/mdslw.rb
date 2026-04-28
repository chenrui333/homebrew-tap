# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.16.3.tar.gz"
  sha256 "72b23644677be7bc1d0d99a1059a5072a6ee3e15996a86ce18a3a4a66552372f"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88d1fa1049682b456ff7cae606ce0a75a2da3edeff611e5e3547a980d6f21254"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "861bdab0b297cf4ef95b17f0f0845c6b4cac25be01ed55a65e9723850d5b3931"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9bef97aeeffd0d0084aa46607d2659bf4a37546946a6ed153376566078f7f12f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19ba38bbf929b0918e0212dbbbce8e4509f8a27cde14030b7774b3e9fac53314"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac3331d1a826189ad6d45ce6d63b93a18f034a06944fdeeb0cc4cf89d757a855"
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
