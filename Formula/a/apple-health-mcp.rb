class AppleHealthMcp < Formula
  desc "MCP server for Apple Health"
  homepage "https://github.com/neiltron/apple-health-mcp"
  url "https://registry.npmjs.org/@neiltron/apple-health-mcp/-/apple-health-mcp-1.0.1.tgz"
  sha256 "998cfedb34d1e3240f0408459e91e01fef5b28953b71889d6159772e0b385c30"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "d3d4b64bb437289caf0ed7b5d3bfdee1251d420ea92e014ddc7e57f5125cd8f9"
    sha256                               arm64_sonoma:  "4983a26fd29f14b1abb6556d4a1305c772d44ff1a42e42397462661c033a5805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5aa33ba8821975c403af23a6c2dc4d0022f72fdc9b5ebed61654ab0d045a8e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/apple-health-mcp 2>&1", json, 1)
    assert_empty output
  end
end
