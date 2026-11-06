class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.16.0.tar.gz"
  sha256 "4deceed942690242022df2c905c606ddd02ff177aaf5b499a9ce727989db069b"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17303986d95e3241cd864f5cca99ea826d27592b50d2085ebeaa62945e5ba55a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42076de0f83db6f007b5ad2ef4184b0839d2c511bd4eeaaf4402cab97bf446c3"
    sha256 cellar: :any,                 arm64_linux:   "d3167507ab224f9319163697d5446afae36b566e823a42d6cb2689d2e1c0dbd8"
    sha256 cellar: :any,                 x86_64_linux:  "3e6c26641e1d94f890f911a0e36067d17e11f3d4a465a3a6d0c8ee1f86847310"
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
