class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "db4af23bed1c1e92c021a7fd360c154263f6488b22a851e7527f20fd79acfcd5"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e9c2a72962d6c71c3c0bd72fd36d31199929dfde85a780be55ccce2216a7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52a8f3975f85527093a942e9b90bf0f3a1c7a2cb5225344130042a99d707995b"
    sha256 cellar: :any,                 arm64_linux:   "5fe54ddf73472fd0d00a56631d0088d35469ce3c8bedd3fc93d69539348e1bbd"
    sha256 cellar: :any,                 x86_64_linux:  "cf57392da1c170459d8a22260d5c6ba2a27b74082892805b3d5502ee95696458"
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
