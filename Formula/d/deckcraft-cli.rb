class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "2240c7ee8fec7ff2425634d9b76a4f3fd332b67db543e865593dedf3d29a1bb0"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "066035b8ebf3c80876b990fa6bafc28d42a84a93160c2e002d714fac673d43bf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "68fdba22592d221a9eea6b0e6b5742b3129aedd9476b1f8df122c5b12d7f31be"
    sha256 cellar: :any,                 arm64_linux:   "18cfbf3ef0906c186c44a132d3a3fa0da840a441fe75cf266eb40c55339ac7c7"
    sha256 cellar: :any,                 x86_64_linux:  "03315a63009a10d0d3232e78f76b647abf6304301913541e344cc77be5bc07b4"
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
