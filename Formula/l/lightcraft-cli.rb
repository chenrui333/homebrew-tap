class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "456c2d41b3981f432909fb5f798044118a29a4ca72066adc490041d9730c7fea"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9280e65028bed792ab2f3689d7155f263e6df4b23cb4e71d3669de647e40d7af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28a5016e87b51997c05cf15970c8fd74f602dacf1d3f59e163df6661cd12e5c8"
    sha256 cellar: :any,                 arm64_linux:   "a49a8b956d496b633cd0ed690a9c810abe7f48fe4dec7efd8affed20002991d8"
    sha256 cellar: :any,                 x86_64_linux:  "a090e6844d20acad528f70469cb54b5a1f5073c5bbe840ed732925230450642e"
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
