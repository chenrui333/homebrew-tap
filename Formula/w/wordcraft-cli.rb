class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "00201455e853ffb34a2a82efdb8a1ce11795ed10339a3f51cfd9dfe468e5227d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dd9f74c4b94657c98540ca7c60adb1aa49644baedda5c80a27a6ed017453018a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "507b03196874139d179eb312eb2e807cf7ffad57f57b7ea9c0cfd691ecaa63d5"
    sha256 cellar: :any,                 arm64_linux:   "dfda178a640744d64c84d3ccd261b3987d7b90afdfd7fe49897d58395273f35b"
    sha256 cellar: :any,                 x86_64_linux:  "94fb190add7b72d3f8251b101f9f62d42c1005a2399c06085c697fe913ca0023"
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
