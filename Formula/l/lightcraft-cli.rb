class LightcraftCli < Formula
  desc "Headless LightCraft photo library and raw developer, with MCP server"
  homepage "https://getartcraft.com/apps/lightcraft"
  url "https://github.com/storytold/lightcraft/archive/refs/tags/v0.19.0.tar.gz"
  sha256 "3d09c282ee23d4369a18044e810d15b55d5067da86bd6aba348289765f0f631e"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/storytold/lightcraft.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "26261370457da172c4cbad52f69a613988a9c0848c890eaf5b55a77a039b7b28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a508cbf065ac1582ac5e931330515019619070091e54ac24e008c8cdeca30838"
    sha256 cellar: :any,                 arm64_linux:   "c40155f1293f06379bb10b8d3a117f2e4ae28482829edc1ff99ba562100cdd18"
    sha256 cellar: :any,                 x86_64_linux:  "fb380e69b1b1527aadca1ada0990b802780c22bbce383da034846127b44e8cca"
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
