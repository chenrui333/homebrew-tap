class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "931c7742bd46e52cbfd033158ecd51345a39dbfa8e5e3de37609428be7d9c982"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e82ea4f69413f35594af803f17683c60b3d617b0148d5e4bab24787d2ea197f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "771bc711027a5c3e8e351c997ed935b2369243cd8b5e45f2bf41c070b5b7533e"
    sha256 cellar: :any,                 arm64_linux:   "cc89d7080a62d5c92f857e8182c3d9551058ca33911d7f3afb000147673b2728"
    sha256 cellar: :any,                 x86_64_linux:  "8fda41e1539a5bc870b891c4a07c4284ac91a3c263b6652a7a8eafa6dc09471b"
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
