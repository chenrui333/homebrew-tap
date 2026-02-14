class VectorizeMcpServer < Formula
  desc "MCP Server for Vectorize"
  homepage "https://github.com/vectorize-io/vectorize-mcp-server"
  url "https://registry.npmjs.org/@vectorize-io/vectorize-mcp-server/-/vectorize-mcp-server-0.4.3.tgz"
  sha256 "610ae57ca32cf79ee6a3cd1b47fb624b1e36529b8ba2ee68c389e25d2aac65b2"
  license "ISC"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78e0dfbb68dc805ccf04a550625e6575f944f3a7da18b5320d4da50c598f7f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60e16d5a504b02f3a20bcdd180ff6f71e05d78e0d5be633727e76b80743f2a9f"
    sha256 cellar: :any_skip_relocation, ventura:       "b9ce70edbcf2d5afa600f82f55d943de67063b7827e24255042f73881858a846"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0804686c79a2e1959651b03c57d19e4806351d36ea03ea3943c93f8de466ecad"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
