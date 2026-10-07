class VectorizeMcpServer < Formula
  desc "MCP Server for Vectorize"
  homepage "https://github.com/vectorize-io/vectorize-mcp-server"
  url "https://registry.npmjs.org/@vectorize-io/vectorize-mcp-server/-/vectorize-mcp-server-0.4.3.tgz"
  sha256 "610ae57ca32cf79ee6a3cd1b47fb624b1e36529b8ba2ee68c389e25d2aac65b2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "1b7bb1de52a19cc34f9f9ba37c8e1fba0500ee9b42bab316dee8c782ae25f428"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["VECTORIZE_TOKEN"] = "test_token"
    ENV["VECTORIZE_ORG_ID"] = "test_org_id"
    ENV["VECTORIZE_PIPELINE_ID"] = "test_pipeline_id"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"vectorize-mcp-server", json, 0)
    assert_match "Configuration: Organization ID: test_org_id with Pipeline ID: test_pipeline_id", output
  end
end
