class McpServerCloudflare < Formula
  desc "Cloudflare MCP Server"
  homepage "https://github.com/cloudflare/mcp-server-cloudflare"
  url "https://registry.npmjs.org/@cloudflare/mcp-server-cloudflare/-/mcp-server-cloudflare-0.2.0.tgz"
  sha256 "38ac732f0a1264dc05e4db8c2ceef3be59f8855580a77fd5f71af2962d8ab0f9"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5970eac3661ee7f5ddff829cd99f6dfe0f50c203db4ad213fe501321c2f8b709"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5970eac3661ee7f5ddff829cd99f6dfe0f50c203db4ad213fe501321c2f8b709"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f1fa7a4b0ebe4d31adb68547c766028f41b85ae9a92c0ffe4e4bf6c9fc3da13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f1fa7a4b0ebe4d31adb68547c766028f41b85ae9a92c0ffe4e4bf6c9fc3da13"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match "No config file found", shell_output("#{bin}/mcp-server-cloudflare run 111 2>&1")
  end
end
