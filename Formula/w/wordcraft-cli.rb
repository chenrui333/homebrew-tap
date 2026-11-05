class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.15.2.tar.gz"
  sha256 "931c7742bd46e52cbfd033158ecd51345a39dbfa8e5e3de37609428be7d9c982"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "916c3309e647211e0733b695eda1a2afb7c9da1dbb56ef1c8bb55105c590de7d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "92de9a47e5ccf1fe0a1b07f70ef35b212cb713e1766d1ec52a484e81e2e8916f"
    sha256 cellar: :any,                 arm64_linux:   "e3400c4e4cd0c3bbfbe2ee603857bd2cefe669230142bb2abab444e40e7729d9"
    sha256 cellar: :any,                 x86_64_linux:  "9ba06a64c1f3072bad000beec68c0ed7a60beb411b369bfe93caa051d865db61"
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
