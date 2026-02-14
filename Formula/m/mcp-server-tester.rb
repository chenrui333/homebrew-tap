class McpServerTester < Formula
  desc "CLI-based tester for verifying that MCP servers"
  homepage "https://github.com/steviec/mcp-server-tester"
  url "https://registry.npmjs.org/mcp-server-tester/-/mcp-server-tester-1.4.1.tgz"
  sha256 "5941077555e91ae5cb21dcec7d7cb9b9e03e07bc24f62c7c4384400b1a5d43fb"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22969bc70ace702a9b5b127a223b2dd4d93fbed6d8e7ef0b2aacd9902a078437"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9dfd0460220b8de30dae5e7801d58232c05f21734f9f6c7ead1d295162cc114e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd95711dc97aaec04c7a314ad0c0ec8ac1ccdfbdcedb99918e29163f58161897"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41edc75d887fc1d1baa1b79a22ac1a2406740b86ff3ebb29d059458d63ff9bc3"
  end

  depends_on "patch-package" => :build
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mcp-server-tester --version")
    output = shell_output("#{bin}/mcp-server-tester schema")
    assert_match "Schema for MCP unified test configuration files", output

    output = shell_output("#{bin}/mcp-server-tester documentation")
    assert_match "The MCP Server Tester is a tool for automated testing of MCP servers", output
  end
end
