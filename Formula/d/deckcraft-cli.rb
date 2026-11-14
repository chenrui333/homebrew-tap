class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "df8827f38677020445a68d5fd5779adfdb74dd72b127c3d06ba7dff60fbfa738"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83c986a8e1baa911eecd9751d07536f1e1eb4277fba45ef05f1b37b5370f3066"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57653f456e78ec644996407beeb16ac694761c0ad7009b258bfddf770a2f314"
    sha256 cellar: :any,                 arm64_linux:   "1e526e7c4df925e90923159453904d985ba56169aa21977e78858fae89a39f4d"
    sha256 cellar: :any,                 x86_64_linux:  "a606bc5f06eaea45a3e6a3daa7601ae572639cbc32bf44e92a18c4601838c22d"
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
