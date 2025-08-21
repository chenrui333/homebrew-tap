class TerraformMcpServer < Formula
  desc "MCP server for Terraform"
  homepage "https://github.com/hashicorp/terraform-mcp-server"
  url "https://github.com/hashicorp/terraform-mcp-server/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "6148a9099899fab41a818bd905b8c6f495ceb5105d3611d3192b2e677924778e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-mcp-server.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "157d67d8f3e79e67ac18abcd95902ad2427b05a825c7cde11620e9ee04bd9eae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a847ebf00f10204a7cbf2d3836d826b46dc057c62fd792afd6dfe0f9f692008"
    sha256 cellar: :any_skip_relocation, ventura:       "f61cc63279ef284ea04f0650d4ffe076a79326de14399fc4d8f12b8e265d7ed8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "512a1e7780f6b101c1e0e01e945c7270d307391fa0452fa878eaacdd5fd404bc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hashicorp/terraform-mcp-server/version.GitCommit=#{tap.user}
      -X github.com/hashicorp/terraform-mcp-server/version.BuildDate=#{time.iso8601}
      -X github.com/hashicorp/terraform-mcp-server/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/terraform-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terraform-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/terraform-mcp-server", json, 0)
    assert_match "Fetches the latest version of a Terraform module from the public registry", output
  end
end
