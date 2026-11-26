class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "0803595a9a6cf24f13891558c4b5f83232beb2c230d7a3174379b04fcef520bf"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "5615f44da4ebbbe856a25cc97baccb4aafeba8bf57456b1e34d0d45cdf190ef7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4141d46cae1b094e8a2dc1029ed8490e7e60d1a745c091a7df8f36e4ed16c1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "862bf7c478b0dfd669c845b6114e2c4204d42efb4a1cc5e1a88748c0e8b43bd7"
    sha256 cellar: :any,                 arm64_linux:   "8352ca48419a647e310cea18b198c02709816e05e8f760257ecc38d16bdd0f7c"
    sha256 cellar: :any,                 x86_64_linux:  "7e83cc67f2f4c1430e4e743ec668d135dacbb3dd2c1190eae444fa859c851f1c"
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
