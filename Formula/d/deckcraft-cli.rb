class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "eb605c5a89d065c29f6839fdc336f08bf6ead924f6ce51295ed91b37a5a98390"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8686045a5a8b86631a552a335d10c4a4abe88ee479833a249f46404fb9e6f0d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14a9d368039bf5e9f245e6344730f19f1ba9961c28d23e9311846af21784698b"
    sha256 cellar: :any,                 arm64_linux:   "d31810f97c980ce8c50fc5526ff157f9bf27abf0f3700460f8b5c2824c594bc3"
    sha256 cellar: :any,                 x86_64_linux:  "c5eba5a0f7dd435c76441fc71799216fbce703339ba76f194eb5e09c69e60685"
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
