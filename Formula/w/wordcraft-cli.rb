class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "55e6e6ca0e988a7ba320bef506e3910d2e2e5c1d1599a79571e144947438ab92"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "42413f749047ca0feee3c661313c06b81b7a48aee584ffb9e6a47b97b3d2c098"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "937af0d5d4e4003da0a9be236ee0df796ee495a06cb678e3f1bcf6d7cd11efdd"
    sha256 cellar: :any,                 arm64_linux:   "61900a1aff5771a6617c887d0a7f84708ee6c9ef06ea7592e0267d41ee3171f9"
    sha256 cellar: :any,                 x86_64_linux:  "67f4358020ff08f2ecf42f43ef44a913f5ffafe083502b2b1fa068e4c135ab0a"
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
