# framework: clap
class Mdslw < Formula
  desc "Prepare your markdown for easy diff'ing"
  homepage "https://github.com/razziel89/mdslw"
  url "https://github.com/razziel89/mdslw/archive/refs/tags/0.15.2.tar.gz"
  sha256 "4bfd409054c20a403d9f8e7b4b3f11dabf421752507ed5da4381bc3515caa39f"
  license "GPL-3.0-or-later"
  head "https://github.com/razziel89/mdslw.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dea0ca4cf76b286caf5c7e5b07b0b6ec9aad0a5a690bc0a51862f419c42dcaf5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d76e2ae1d003b196f040ff368cbfb7d8403d469c7c750f1c2b5dff4aef1b6274"
    sha256 cellar: :any_skip_relocation, ventura:       "72007b1ca8eac9f50efa24418cb5a5f1cdeb6b1294b70724f984ca06bb605a5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d408ef91a48faf8b70f154f81f0c8fa1d5db139c64192d2cb2af1e44281cb97"
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
