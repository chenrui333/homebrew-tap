class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "da592ba01b21c8a281067e223826b62e3988a0c93032297c9b23e7b8fb844baa"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c40df9dc3125391248ede2c22004050674abd5ac18f04d18ccb3a9a35e63196"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59e924c726c2ac0a8f0340188ab819ef2a854572bdd3aac0697987386cb37278"
    sha256 cellar: :any,                 arm64_linux:   "34b6a355008d07bd67d25928db7ea0b74d27862bf99003d9277ffaa6c38f4ba5"
    sha256 cellar: :any,                 x86_64_linux:  "711bbfb8352abf910a98b85d436c2fc6120d96b5013a743a0ce06730332da3de"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/lightcraft-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lightcraft-cli --version")

    controls = JSON.parse(shell_output("#{bin}/lightcraft-cli controls --json"))
    assert_includes controls.map { |control| control["id"] }, "light.exposure"

    cp test_fixtures("test.jpg"), "in.jpg"
    system bin/"lightcraft-cli", "render", "in.jpg", "-o", "out.png", "--set", "light.exposure=1"
    assert_equal "\x89PNG".b, (testpath/"out.png").binread(4)
  end
end
