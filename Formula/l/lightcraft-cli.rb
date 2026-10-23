class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "e53a5b91fe837d25cba273675694cb18abaabda78143d84cc0f61f2edc608da1"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93e85c6ed1db5c051595ac617f9af4bf63ae7e66b3a0c39a3022ac466b349376"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2b8edd90bb7adbf50ff214b073695c6d00698461cde11ce1e515f25b291e09ae"
    sha256 cellar: :any,                 arm64_linux:   "7fbf46c4ab39e78d7300eb40477cb9ed526ec3a906714ed4336b8beb62df4e0c"
    sha256 cellar: :any,                 x86_64_linux:  "12ae37d06c493209c8da371535b39411ab9bd00b41fcb10a32729d4e013074ba"
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
