class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "5e689147e46ed78fe100d43db997e64e7266e2d02db898bedec1f9a30e80f474"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e005c9f7a1b60fad8c7baf27f919313886f97fd7cdde2c7ec791feed0c0561d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87c5b689e0ebf80db750969bbbadfb88ff05cf02bb00acc1ed39ecc586e7084f"
    sha256 cellar: :any,                 arm64_linux:   "e23d8051a57d0bc594f3d036fe2aa8d32cb2a9548387a990c1957a98efffbaa6"
    sha256 cellar: :any,                 x86_64_linux:  "1a32a12d36cfdeaaa128dbba76e5f7278932c7f12c291fedc131b5c5f47b26e0"
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
