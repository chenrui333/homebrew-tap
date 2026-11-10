class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "2012e3462595d712764fe23d1786136ba2e50907fcac3d08b1a3b2dfdcfd4d9d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97db8402ed9aeabd4b98753ad05711245fa4f8a688ceb94ca49f6f20eb078f84"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "910558c5d4120b04f458c40571f58309b5908224d3cb692f03e83c2e63ce2451"
    sha256 cellar: :any,                 arm64_linux:   "231c736a92e3ef0881b2959b76ab185895b3fe6c8191672618ca020dc8207b31"
    sha256 cellar: :any,                 x86_64_linux:  "3133a9fadadab5da0127063565c78a66232dcef675c6c80a1d073e6496200075"
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
