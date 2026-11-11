class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c207bee434644a91f47c5fafab672d5c4280a4c3d8aa9b3bf13d6b9c43b83cc9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "271d5210e1678ed256018ef35ad34917c64e8739a009e7946ab1e20485cc5543"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5724a5de0381d3c47320a7c8e5a98c3837773c6dfe16cfc21900d1576a9d4ca6"
    sha256 cellar: :any,                 arm64_linux:   "b980e4a253b4cb1b214e5939489fbc1217bf63edfac58ab93f3da6b591b1f9cb"
    sha256 cellar: :any,                 x86_64_linux:  "c19e9eddfea0492abb1ef39c018dd26aa17bd1718facd74d77e76024777a5a5e"
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
