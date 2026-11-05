class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.15.1.tar.gz"
  sha256 "8c73c88857634b8ca6119738186b2db6e85c97c0f53c249ff0db42123bf01c0b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c57d0872a9f03b6612a1f0fc526861239e1b9db457e1913fc0cf99c70f774b17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61bf43993673e1cef033be8ac4a260182d8c9f01c95c36fd46ef4f01d71c464c"
    sha256 cellar: :any,                 arm64_linux:   "594fc9223a59d82ca1a5345128d45f7fe3c3f56634ab37d293e406ef414e73ec"
    sha256 cellar: :any,                 x86_64_linux:  "fe2e5f8d378ccee8abf5279c03b8439e19fc8683dca597cb37b9b6ea3cd636e6"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/deckcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/deckcraft-cli --version")

    system bin/"deckcraft-cli", "run", "--cmd", 'slide.new={"layout":"blank"}', "--save", "test.deckcraft"
    info = JSON.parse(shell_output("#{bin}/deckcraft-cli info test.deckcraft"))
    assert_equal 2, info["slides"].length
    assert_equal [0, 1], info["slides"].map { |slide| slide["index"] }

    system bin/"deckcraft-cli", "convert", "test.deckcraft", "test.pptx"
    assert_equal "PK".b, (testpath/"test.pptx").binread(2)

    system bin/"deckcraft-cli", "convert", "test.deckcraft", "test.png"
    assert_equal "\x89PNG".b, (testpath/"test.png").binread(4)
  end
end
