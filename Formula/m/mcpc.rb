class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.2.4.tgz"
  sha256 "aeb855bf09cbd4c8142332378e304c80f3943db198d512ea1216becb1e93ae0e"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "88b0ec4dd52fe33863ed6a20324e3d1955915758fd5baf430ee80a67227c870a"
    sha256 cellar: :any,                 arm64_sequoia: "3648cc1dea39bd2f66f7ec6e9c47595188d572fed4a121ac00df6a1b287afa43"
    sha256 cellar: :any,                 arm64_sonoma:  "3648cc1dea39bd2f66f7ec6e9c47595188d572fed4a121ac00df6a1b287afa43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51c3dc8b6dcd7df044d5ebcb9cfe12ae96c8a7b54336c5ad9ca1617424b562c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6fe5a8ad4914bb360336746b46a0411e2ff54f5d66e00a266077f7a5e2ab4f3"
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
    output = shell_output("#{bin}/mcpc https://tools-list.invalid tools-list 2>&1", 3)
    assert_match "Failed to connect", output
  end
end
