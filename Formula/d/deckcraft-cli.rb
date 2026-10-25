class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "b32008657c0d14c70953c75b7f06e729443d6eae733b5105bbebc2f835b1ee15"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "753217ab2e89a5a7ac2d56115271c5de65112e3553f5eebc12033921b0c82ab5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f6db1d2d27d1d2c9b485c7214eff5f9ed42f296b56fc22a40ae117554c0430c"
    sha256 cellar: :any,                 arm64_linux:   "aa99150382a987470b68f01a1965f76972c4439d2c3ad12c9a6cbe13c7ab8a62"
    sha256 cellar: :any,                 x86_64_linux:  "7ae549392bcb1a20a65b228a822e543f413d59084e37cf6b5707a6b6985269bf"
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
