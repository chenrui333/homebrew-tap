class DeckcraftCli < Formula
  desc "Headless DeckCraft to render, convert and script slide decks, with MCP server"
  homepage "https://getartcraft.com/apps/deckcraft"
  url "https://github.com/storytold/deckcraft/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "7d006ea34a5dd15c4c0f1ea89f314f9e6ec2103d5c3b803649ad77c6ea0d68b3"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/deckcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea7edd1fdd529d78dfc2b6de2723af9c6aa1ccb4576e9ea41a4e3dd1475cc115"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81e1c19d6ff824cf7a4ad336f2a153fc6e576ca02f82af194f7ab5edcbefa976"
    sha256 cellar: :any,                 arm64_linux:   "83478e15aa826af9cd166f4af302b39f35e14398d1931e22a649f63057bea100"
    sha256 cellar: :any,                 x86_64_linux:  "7ff00cfa0f74346ec2e20dee67ae70e0572e21f2f6929433e77c6503582391fa"
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
