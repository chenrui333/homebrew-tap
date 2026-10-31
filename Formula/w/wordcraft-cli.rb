class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "f5b36f6f57eac8d2f6a2f8fd0be97d8ae46520b3bda796d4ddbfd663140af3f7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd13ca881e99a390ce8b3fa740aaa1099f26f4464944e57c95de5fa6bd566f8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb0786c805c0037fb1df09d4f23702147d81b32bcab38b70cc7f4275e63325e"
    sha256 cellar: :any,                 arm64_linux:   "9e9a59c86b333ec607288b493012c80fbad69c24a9703b8945adc854b1ffab17"
    sha256 cellar: :any,                 x86_64_linux:  "c606849bf01f7de1016490c356572f3099a7fce60200751e8242760b56dc6b4e"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/wordcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wordcraft-cli --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Homebrew Test

      Hello from Homebrew.
    MARKDOWN
    system bin/"wordcraft-cli", "convert", "test.md", "test.docx"

    text = shell_output("#{bin}/wordcraft-cli text test.docx")
    assert_match "Homebrew Test", text
    assert_match "Hello from Homebrew.", text

    info = JSON.parse(shell_output("#{bin}/wordcraft-cli info test.docx"))
    assert_equal 1, info["pages"]
    assert_equal 5, info["words"]

    system bin/"wordcraft-cli", "convert", "test.docx", "test.pdf"
    assert_equal "%PDF", (testpath/"test.pdf").read(4)
  end
end
