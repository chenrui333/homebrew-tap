class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "c5e91ca9cb2b87509648e5633722a251eaf12d95dffd84ef46aec2aa858066e8"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a654752013906c2d4c7695d20b5fe66bd1e2ab53a6f548e05a4dd03fe1259d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e85545364725f925bd0e791a68f8c0d7d918ecfdbb028872d4ad951f81c725b1"
    sha256 cellar: :any,                 arm64_linux:   "2f3953499d6617991185933810347c09932d96f708fc3e900da0372fff412d96"
    sha256 cellar: :any,                 x86_64_linux:  "a2e2afb2eb97764de3ea93255ab6639237d71449f642bd0b6eb9d6d39b3dc5fa"
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
