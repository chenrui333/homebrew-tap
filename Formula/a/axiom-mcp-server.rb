class AxiomMcpServer < Formula
  desc "MCP server for Axiom"
  homepage "https://github.com/axiomhq/mcp-server-axiom"
  url "https://github.com/axiomhq/mcp-server-axiom/archive/refs/tags/v0.0.5.tar.gz"
  sha256 "11bcaa469544c175b9e35f5694644064aabe74b425a250c082fb5e19cbc257a1"
  license "MIT"
  head "https://github.com/axiomhq/mcp-server-axiom.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b0d213f098b69da308bf0eef1d97954869ecfb1ade40f74c381f8b2861c8ebb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b0d213f098b69da308bf0eef1d97954869ecfb1ade40f74c381f8b2861c8ebb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b0d213f098b69da308bf0eef1d97954869ecfb1ade40f74c381f8b2861c8ebb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb3f2bbd94a67e06403e61be16a8b009e34a01ab3b93bcf62f72383f1fc05c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfd28830b872c92602de75d3b597326aa1cab4bcce9790b024bed016dff43bf5"
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
