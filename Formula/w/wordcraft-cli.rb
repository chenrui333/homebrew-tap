class WordcraftCli < Formula
  desc "Headless WordCraft CLI and MCP server to convert, inspect and render documents"
  homepage "https://getartcraft.com/apps/wordcraft"
  url "https://github.com/storytold/wordcraft/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "d35c399acbd438c3c536e31a78f35d3fc7074afcc992e8c7e092fc41fb866aa6"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/wordcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6471c395dbe7f727dad1cf5d27f5e87e262889b4da2cac3b8ca4b218506c4b48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "107e6f3c25d53885be09f1f44959620cc97d86ce9b27cb7ace2155deb107bbee"
    sha256 cellar: :any,                 arm64_linux:   "d9e269bd7e9f4bcc358f9b3844990670aae058f1bbda08d316dbec63f785150c"
    sha256 cellar: :any,                 x86_64_linux:  "aaaf7fe77ecf37f1991764a0efe65b649d5071c83154bb1605909fdb57cd4633"
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
