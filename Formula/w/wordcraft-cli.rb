class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "ee70e31d3b887c7e2c4b7d31de612ffddfb25a9359ed17d734b21a3b7f6891c0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe17cb830a47843c53dcb89ee589da63f35e0d4383f4fd99b5a11ba67fefa120"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3623f853a6da3c82b7936a6b3da54452515beb692f307388d93888e1e24751c"
    sha256 cellar: :any,                 arm64_linux:   "bc5807f4d786477dc3502d517c98fc3261475bfa07b117175e1ce6a793d56b39"
    sha256 cellar: :any,                 x86_64_linux:  "745d5d5f0b05531337164a8999ee6de0eaabb1724dfed34ea20754aa6d79fd0b"
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
