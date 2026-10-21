class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a2b2850a8cfb192ce8cc08b2f5b014ef09606116c6bd1f011afd392fd663acea"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4cc83d45c96184cc5cf65a5a979fb183854dde32dc65f7af4ae3750f27c3900b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2029e2aa1455b80cfcb5310679fdcfe5399740f8a60e729a96b48e2f019f945d"
    sha256 cellar: :any,                 arm64_linux:   "6385a432d9f30d1851581b54de61d3ea6bf280689c8b060f037137bb940f9d48"
    sha256 cellar: :any,                 x86_64_linux:  "50a7593e08d6208c3334f7b4afeff918c4f6e9a47a84a0704e7a751cdd291580"
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
