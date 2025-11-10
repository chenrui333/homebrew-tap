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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6edaa1de22930137f7252cfdf09f4091c918b67c82d69962d9ad60723318af3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6edaa1de22930137f7252cfdf09f4091c918b67c82d69962d9ad60723318af3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6edaa1de22930137f7252cfdf09f4091c918b67c82d69962d9ad60723318af3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0401a6bdf573ccacc68e7da977d98c1834182b13982203731fb2a990b7bec1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "925740e554981fad82e851e8235b27b3c7668d28903bec91e3ba583e81446b3b"
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
