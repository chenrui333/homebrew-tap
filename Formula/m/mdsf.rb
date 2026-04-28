# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.10.6.tar.gz"
  sha256 "87ed459b94ee5ccd9ee28362035c6256b0ed43fb8333b0e47860f2828c170263"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b069732e0c5fa4e64017b579d023dd8490d170bec00e1ed35b8f187c72daddb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d87cf7111a8a5bddae748f18b43dd6f6decf232ba8576550b9cefeb7e6ef3f7"
    sha256 cellar: :any_skip_relocation, ventura:       "fa741a924c24bb559f96f3a324ea7b79c102e0d21bb6384552f72f257c00c3ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd43741182aa5c8612fda3cf15f57b9ab2adcea87c971dc323a49b5f6f8641fe"
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
