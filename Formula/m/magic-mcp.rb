class MagicMcp < Formula
  include Language::Python::Virtualenv

  desc "21st.dev Magic AI Agent"
  homepage "https://21st.dev/magic"
  url "https://registry.npmjs.com/@21st-dev/magic/-/magic-0.1.0.tgz"
  sha256 "3bd43e9ecbc55e9dd1d55c7760f3e57f506624d7c73337899dd7329ac6fd74bd"
  license "ISC"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
    mv bin/"magic", bin/"magic-mcp"
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"magic-mcp", json, 0)
    assert_match "Use this tool when the user requests a new UI component", output
  end
end
