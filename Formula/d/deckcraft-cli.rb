class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c5e91ca9cb2b87509648e5633722a251eaf12d95dffd84ef46aec2aa858066e8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8c16cdb4374fcd0d8b3d6d9577cbdaa54a361087e592924eaa5498bc645ff0eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d7e4089aca03b129d8676737039cf1ed849e5b0fb9119df270e1e909ad91d219"
    sha256 cellar: :any,                 arm64_linux:   "8ff2d2afe954492ef5b855046ed5e215061eb7ce994198218fbcc6d2dcb32c3b"
    sha256 cellar: :any,                 x86_64_linux:  "3d321ce8b69b0b3b8991624ddda4b0fcf675c1725260e79542d77f345fbd64a3"
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
