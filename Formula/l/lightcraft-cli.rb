class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "85b6285e2153d3dc8ac2c2a44b4967a9c9d106ee3237dfb6b2f90313ce5d5035"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b58b4f5e3e9ad295e947a8d21655870d17872d39812d2b3c6f17bcf329dfa705"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad9ec82a2c926f34d87fab97baa233496618be5676f2e93776c28855ba8626ac"
    sha256 cellar: :any,                 arm64_linux:   "1c63923c6364b50cec26b87a3f8a84a28d16285ecf645695965939abd08c05a6"
    sha256 cellar: :any,                 x86_64_linux:  "605747a92bf6a6e4b2b05c6d61cae65185701a068e509527e0d78f19ffd743c4"
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
