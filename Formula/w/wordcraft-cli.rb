class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "ff57541e7a6b71b8ab87b52a0736e71c783c003f7fb2470ccf9352161632f46d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbaceb9fb63203942b4e4ad032e565e1f7d76dc7985c4dd2358a7df4ae3450f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c819e21f078402a4b10d1f8836e1bac248f71f807da17d99624638bc85ce5dd"
    sha256 cellar: :any,                 arm64_linux:   "e0b9d6e1eaae59236203b6256f8e34e566a013d927327e5b44958d1a6802cdd6"
    sha256 cellar: :any,                 x86_64_linux:  "70257f039184ae59e88761cde6316ec55bd35a88e834b642a1ead0f5601c6526"
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
