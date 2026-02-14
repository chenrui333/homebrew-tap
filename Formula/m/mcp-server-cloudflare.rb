class McpServerCloudflare < Formula
  desc "Cloudflare MCP Server"
  homepage "https://github.com/cloudflare/mcp-server-cloudflare"
  url "https://registry.npmjs.org/@cloudflare/mcp-server-cloudflare/-/mcp-server-cloudflare-0.2.0.tgz"
  sha256 "38ac732f0a1264dc05e4db8c2ceef3be59f8855580a77fd5f71af2962d8ab0f9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2483fbb6b676ec7d58edb90e38823e14a10667872db078110d6035cd08497e3d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea9be73e09a703827b2a7c4fda349dfcd3a727312dbf0235078d23e6bd4d0bdc"
    sha256 cellar: :any_skip_relocation, ventura:       "1a6e76690b194b4ee352c2c1eeeef09b203327b7fa4bd203d3ebef38dc572ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2a8dbe78228ce18a73ba48fcb962934d636eb4f1c2987f5371c392cf7c4e498a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No config file found", shell_output("#{bin}/mcp-server-cloudflare run 111 2>&1")
  end
end
