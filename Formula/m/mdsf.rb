# framework: clap
class Mdsf < Formula
  desc "Format, and lint, markdown code snippets using your favorite tools"
  homepage "https://github.com/hougesen/mdsf"
  url "https://github.com/hougesen/mdsf/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "9d65d6579af0de57d1e50ab1cd0a5516ddbed9f82c065bc70c466b290a777f45"
  license "MIT"
  head "https://github.com/hougesen/mdsf.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4528f7f23201c43f61c03515f3534e2aacaa4b6b02136650fe75ed38b0fc344b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "025c28819824c221a6b3786bdd211ae92fd72d3682f11b057a8982f5f437974d"
    sha256 cellar: :any_skip_relocation, ventura:       "a8da2deff2dc9027a035b686587fbed9f7b47fc84811d5d3dced12c75c6b79ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e0008a9f7ce21d87ecc7bcfab81a48fb484040388112616c0119151226465ad"
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
