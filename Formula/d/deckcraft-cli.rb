class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.14.1.tar.gz"
  sha256 "6e03f2e9532c0102ec01d8be8bba556a0191ee11d5ca64412a5b48457afddfb7"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da431ade26eaa98ad4c699560dbdfbb294ae2208d0ffcf520c3f458ec671b048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1a9df7847900e5feb53e509eb588c489b611bb5f676c04f906fbdf34ab62e76"
    sha256 cellar: :any,                 arm64_linux:   "f2de8a2389ce948984f53f43d747898ae408a3e5eee6932785832494df345ee5"
    sha256 cellar: :any,                 x86_64_linux:  "c63999301eb77ad95065973328639708decbb574a872f57acc72c009c3bbfdcc"
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
