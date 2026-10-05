class MagicMcpServer < Formula
  include Language::Python::Virtualenv

  desc "21st.dev Magic AI Agent"
  homepage "https://21st.dev/magic"
  url "https://registry.npmjs.com/@21st-dev/magic/-/magic-0.1.0.tgz"
  sha256 "3bd43e9ecbc55e9dd1d55c7760f3e57f506624d7c73337899dd7329ac6fd74bd"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "20f396076eed836a1adbeb71124b5bbc519e48d91883cac92578a9bfa5ff9bdf"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec/"bin/magic" => "magic-mcp-server"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"magic-mcp-server", json, 0)
    assert_match "Use this tool when the user requests a new UI component", output
  end
end
