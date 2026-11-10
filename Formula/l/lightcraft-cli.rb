class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "a528687d7a3431e1a20018cb1c9f75222fbddaf72c703275c1acca79b0f87a2c"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf7e2f89b8e28021b85517340c6efe622b19e43fa5650a416f9c0022754cd553"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30719ee9d85d647683a7afec994232c3013b3c117e02607c9b9148b9e42bcc27"
    sha256 cellar: :any,                 arm64_linux:   "ab3f7924fb07feaae226df3dd0bc62f0ba99b79c76a473e16d104b291a42f5d2"
    sha256 cellar: :any,                 x86_64_linux:  "42c3364c6d1b37196744650df99990190a3c6c7be93b93af0630de1e6d27bc09"
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
