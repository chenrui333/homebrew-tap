class Mcpc < Formula
  desc "Universal CLI client for MCP"
  homepage "https://github.com/apify/mcp-cli"
  url "https://registry.npmjs.org/@apify/mcpc/-/mcpc-0.1.11.tgz"
  sha256 "4703184e83fa44be5e7ae5150b7d86984803328122b5d2a71021f5d549b8caa4"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1587b6ba60fc5896b5db991104504254d3e9b59644d2f7efee239ba016dfc3d2"
    sha256 cellar: :any,                 arm64_sequoia: "087afd9288f24dfb10dd2e44af23924049995fc6c4f66bc48a9e5f813af08384"
    sha256 cellar: :any,                 arm64_sonoma:  "087afd9288f24dfb10dd2e44af23924049995fc6c4f66bc48a9e5f813af08384"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "566d4c25db7b6ba4515aaf078e619564ea689c139dea949a499609febd8f77b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dc4dcc7e0aa7f35849f8e72b52e589603ae4efa3948814571c83e2134de564f"
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
