class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c207bee434644a91f47c5fafab672d5c4280a4c3d8aa9b3bf13d6b9c43b83cc9"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d50f2ada17ba2d6c8718ca003b11294132bce2fad229d9355572ad8d675c649c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae0d75f4108293dd117bc7a855a98803ef678239509c1fbb46dca9a2d65772b1"
    sha256 cellar: :any,                 arm64_linux:   "9a3757d30d94898d43ae61bb69b26d5c82adc43b4550d87cacc13697209227f4"
    sha256 cellar: :any,                 x86_64_linux:  "3eccb990eb3d4bbd9d95565298cedb798fb1c3f143e2944e72b08f9ef236a375"
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
