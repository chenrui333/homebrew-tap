class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "60a1a393d0dd3d62677c967da8a500f1fa9efc6dbf76b84821498782a2c46f98"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "70fe5ec3bcacd9522c391dd7ca7a7c55d47d575ff30cb65795cf6afaa1fdf393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e4205f7b179e053be5415acf38ecd6321e17b41ba899cdce0d0a7addf03958bf"
    sha256 cellar: :any,                 arm64_linux:   "a8523bf1c044a33639d58cbc1f8fff598e860e21898172adf009129b5c748a6c"
    sha256 cellar: :any,                 x86_64_linux:  "216a95358deb29bf1e1549d5c8135ed98fa47faddee67cdaada0c5750e267e90"
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
