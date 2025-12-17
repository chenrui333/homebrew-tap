# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "77742b8c50ab87a99fe1dba121243fa1283addf1944cc6fa08be0b9838d13d99"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a663b34cdc426ab85dfa2bf6d3999eb4ac0f3558647856777789b0fc202a537"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f316fb572d0b960a494f36a057f72a5053f60e7cb2ee3e3073118b26eddc1b4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b9ee6a62a75d808f38b69a1470df8f159afd168c4457e1664aaded4fdecf9ffd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d5721f987747b3bb4410a341b10e148077957d7de23b44e57d60cd2da88d3b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29440e001aea305585fcae2bc91623e547c0bef59c9c7cf3cee6dc2d239c467e"
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
