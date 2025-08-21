class McpGet < Formula
  desc "CLI for discovering, installing, and managing MCP servers"
  homepage "https://github.com/michaellatman/mcp-get"
  url "https://registry.npmjs.org/@michaellatman/mcp-get/-/mcp-get-1.0.115.tgz"
  sha256 "15b58431832df7c8038faa22dd09110f0daa5da6be7b208afd1455eace428cf9"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11e49160a7965b6112e68d9553f9c52b9355ea6899435f6fca2172bbad06a6ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2387b4959acf553e01604e706fecae9ec71e153a51f156269f320b0b1ce0d54"
    sha256 cellar: :any_skip_relocation, ventura:       "cb2ba3b7a15490a556a4f603464baa79d529d680083b4104a6b8e78fe44d9b36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58463b2a111e4ebba5fce7888c621a97bc24f67e616576847277074025d0c5c7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "No MCP servers are currently installed", shell_output("#{bin}/mcp-get installed")
  end
end
