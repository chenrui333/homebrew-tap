class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "b32008657c0d14c70953c75b7f06e729443d6eae733b5105bbebc2f835b1ee15"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "736db06479c4c803c34eeb4f1bd8493f7a51837acb064009a2338f955841c2f4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74ae45de2231174e64e524bf2b44b6aa7af1246ef5241d9d06ea6e5ea05cf945"
    sha256 cellar: :any,                 arm64_linux:   "9e41246b2106a976e2b6b49d8629766375e6f737d1355bfff798442632eba146"
    sha256 cellar: :any,                 x86_64_linux:  "49317907def314603ed0e1c056b90355be0068bbf6a02bb84b196ae4b92f31a5"
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
