class AxiomMcpServer < Formula
  desc "MCP server for Axiom"
  homepage "https://github.com/axiomhq/mcp-server-axiom"
  url "https://github.com/axiomhq/mcp-server-axiom/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "73920c83e7da63e4747dce3ac867a32458db9079fed56a0b6f3ef7e882b5134c"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1093d30306f09bfbabc09f69a80b54e559c6adf92801cf17fb998eea1f91486e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8270090b281d9a89f3d540bcb9b054995b1206ed69bde728054f979065520fed"
    sha256 cellar: :any_skip_relocation, ventura:       "4fc325de83270cb73b29913a6e405ddb3a3fba9a2cd677cdc5dc958f6b40fbf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f46fc7827c76e13e2d09fe2805048584073336c6e6185e03200cbdca6cdb4af3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.CommitSHA=#{tap.user} -X main.BuildTime=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    ENV["AXIOM_TOKEN"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/axiom-mcp-server 2>&1", json, 1)
    assert_match "create tools: failed to create Axiom client: invalid token", output
  end
end
