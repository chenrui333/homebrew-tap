class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.17.0.tar.gz"
  sha256 "77c5a47d5336665622ac5433afefc7ca9ee2faa100d2b53f0401f4e758d5d8fc"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a3e76fbccf358d8145f53d576f4001208d38a4f113c9ca21e9a2ad7b0a747da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b34f9770052139a16045ad5f767388402cf4990abc2381c9ab720778002afad2"
    sha256 cellar: :any,                 arm64_linux:   "ba5c034095a1a2ebd8ac1ac7081634390bd17be0871d357e8ff5e249057d173c"
    sha256 cellar: :any,                 x86_64_linux:  "cfd41e3a0128ba6024812e0686b6ea717b3a9716c4d4e7b8443290c6bfbce181"
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
