class AxiomMcpServer < Formula
  desc "MCP server for Axiom"
  homepage "https://github.com/axiomhq/mcp-server-axiom"
  url "https://github.com/axiomhq/mcp-server-axiom/archive/refs/tags/v0.0.4.tar.gz"
  sha256 "73920c83e7da63e4747dce3ac867a32458db9079fed56a0b6f3ef7e882b5134c"
  license "MIT"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d93eb17682e9451798edc5ff33bf7fb1a087d652c420adae1949a4390b5da5b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d93eb17682e9451798edc5ff33bf7fb1a087d652c420adae1949a4390b5da5b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d93eb17682e9451798edc5ff33bf7fb1a087d652c420adae1949a4390b5da5b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7b3be5863068c270b1facb6dd0f6a07ac1195ff9c42259affa8d3597e78cbab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11cbf7a64bca4e425dcdf49b6dc7d8183d7609f92ee0505a5b1e2f528d458961"
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
