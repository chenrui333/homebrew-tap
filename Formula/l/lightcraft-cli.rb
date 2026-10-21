class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "a2b2850a8cfb192ce8cc08b2f5b014ef09606116c6bd1f011afd392fd663acea"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "962a78ee0cf4b6ba459749ae7f3b3d6ba787c2ba33c5f0675a19bdc5d05959f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8a51e509ab9b35d47a2d651380ee4865394a82de41fcb34f98baaf8001831d95"
    sha256 cellar: :any,                 arm64_linux:   "7cb0143397f7d97cb3964aa116d7c91958589cf92f48e01aa41a07eeba9a3d1d"
    sha256 cellar: :any,                 x86_64_linux:  "9b146106afaa372fb321cbed8a288542b6cfba122a7b8ba51fed854079dffad8"
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
