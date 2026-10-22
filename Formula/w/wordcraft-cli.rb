class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "3fa36c81490c1b2e08593cafc3de46ba3cebd589d8610dce0c2af4a62f9c1313"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8f23ed788a8112f34771935d931c4d6bd1bad1d0711ec635115e6f281714025a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f2d08ea03bef933a484d8db4a471159111ab11e6ef09b912c37438c3cf0377"
    sha256 cellar: :any,                 arm64_linux:   "107e79171bfbe2b25134f7d4d7bfe0fa98889101bcbe552b6ee7ccb0c87c70ec"
    sha256 cellar: :any,                 x86_64_linux:  "9444c469063b7d32292690486962cc5a302c333120497782680829f6f900229f"
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
