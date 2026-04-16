class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.2.6.tgz"
  sha256 "4a97a72b7094ae0890a6a6409185983e9f3672beea28928e6d23c6b072f39cd6"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0c37a6c7433f47268781990c6b149f120245065f4e6a0bb730283841cc328ed9"
    sha256 cellar: :any,                 arm64_sequoia: "1f9dc90e6af4d8f511d52152ec9da18f7ce38f4a6d605ae2b28c7df76345fc07"
    sha256 cellar: :any,                 arm64_sonoma:  "1f9dc90e6af4d8f511d52152ec9da18f7ce38f4a6d605ae2b28c7df76345fc07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48fee7f7ceb87df73fc365ea2e2488bdb91830209ca8e08776e8184db20734c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e8cf6b173623672352ceff99b3e3650d57a28021e2a1748209291db8d3f6450a"
  end

  depends_on "pkgconf" => :build
  depends_on "node"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcpc --version")
    connect_output = shell_output("#{bin}/mcpc connect https://tools-list.invalid @test 2>&1")
    assert_match "Session @test created", connect_output

    output = shell_output("#{bin}/mcpc @test tools-list 2>&1", 1)
    assert_match "@test", output
    assert_match "tools-list.invalid", output
    assert_match(/Failed to connect|Connection closed/, output)
  end
end
