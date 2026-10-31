class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.13.2.tar.gz"
  sha256 "f5b36f6f57eac8d2f6a2f8fd0be97d8ae46520b3bda796d4ddbfd663140af3f7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "871141b38a086a515c23d4a96e660b74f36a0b47f99ad0cfc6539a793a41b4b1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78ae799fe939768bd5fbc6da8abe31c7a8659fbb86c68cc340ccee5867b1f612"
    sha256 cellar: :any,                 arm64_linux:   "242967f23aa7b0bd1ade891a6a2771fd27398b6afb74073de9f2a9e7694bb017"
    sha256 cellar: :any,                 x86_64_linux:  "13b62dae86f9c975d064219d7abeb8d1c2509ec04ae7a81b73b6cc35dce64eff"
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
