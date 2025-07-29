class GiteaMcpServer < Formula
  desc "Interactive with Gitea instances with MCP"
  homepage "https://gitea.com/gitea/gitea-mcp"
  url "https://gitea.com/gitea/gitea-mcp/archive/v0.3.0.tar.gz"
  sha256 "7f0bb64d2713ab90b382f52e845f1b5406db9fa5657dbc3e21a19e1634ae77b8"
  license "MIT"
  head "https://gitea.com/gitea/gitea-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff0326bbc334fab7a9433070febbe617f1aec4816ab7ffbec458172e88ece86d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1d2f742544b1fec28f56b18762fcd445efd49eb7e11034f9c2be24f4dd29f43"
    sha256 cellar: :any_skip_relocation, ventura:       "00b06073ae7455214e65a6f13c90653a373c6d7c58db7dc1221802e015f0e2de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d70c553310649c2f60d9264907ed6a2ac4c983f07c0717451fcbdfa9ae192394"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Gitea MCP Server", pipe_output(bin/"gitea-mcp-server stdio", json, 0)
  end
end
