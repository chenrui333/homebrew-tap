class McpServerAirbnb < Formula
  desc "Search Airbnb using your AI Agent"
  homepage "https://www.openbnb.org/"
  url "https://registry.npmjs.org/@openbnb/mcp-server-airbnb/-/mcp-server-airbnb-0.1.3.tgz"
  sha256 "0a7e5db6a14807987c49667f8c8cb17e81fadef5b4e0a3f3fa03ea78d788ec6e"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0e626cbeda4cf302ba67a54e8f78697d3d0af3ca193546624d45a4ce1585a0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "234111b8395a6293c94baa31bd11f0cb15c4cde1e046afe28e5a8203372ab412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eafc2614567e2521f06904345b5013e0dd136a85269a5476294121622e5aa3a7"
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

    output = pipe_output("#{bin}/mcp-server-airbnb 2>&1", json, 0)
    assert_match version.to_s, output
    assert_match "Location to search for (city, state, etc.)", output
  end
end
