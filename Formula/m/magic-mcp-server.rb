class MagicMcpServer < Formula
  include Language::Python::Virtualenv

  desc "21st.dev Magic AI Agent"
  homepage "https://21st.dev/magic"
  url "https://registry.npmjs.com/@21st-dev/magic/-/magic-0.1.0.tgz"
  sha256 "3bd43e9ecbc55e9dd1d55c7760f3e57f506624d7c73337899dd7329ac6fd74bd"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcd88f6255c53e201bffbf4c52297ee0fcd361f9863d8030fb9351b46ba5b6f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c611036baa1137be3c55bade9cfbab944bff4f8fa01de172ee94d5a599d3c799"
    sha256 cellar: :any_skip_relocation, ventura:       "1308de93868bfd41b310c9ac01a8a267e99f17ab07a0c4ba8dcc40ac22435867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac4b5f8879f3766e46155eb071e8e7d0a7df198ca2d342f30aa85948b26a04c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
