# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "2976bb38999b69e5c588b4bb63b57bf0e220a95c1f1f83f71e5f6f9dd166ee57"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f97a3ae6fd9dcbdc4e9b89e880e187cf12e620b3146f6fcd52b2bb0cc0ccd220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2c15d67ccf89bd4f6ba287d65179f44262e6e112554c3e4ac304b34f2314f59"
    sha256 cellar: :any_skip_relocation, ventura:       "8ba730955c9c1a1e297f56e93afe2c36a64314761b4795232edffe111d1eb144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84e009d0a37e658d82e9a57ca20a7cf98e77ec13dc036da0384c9a490306310e"
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
