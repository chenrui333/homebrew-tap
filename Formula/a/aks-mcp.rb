class AksMcp < Formula
  desc "MCP server for Azure Kubernetes Service (AKS)"
  homepage "https://github.com/Azure/aks-mcp"
  url "https://github.com/Azure/aks-mcp/archive/refs/tags/v0.0.10.tar.gz"
  sha256 "7ffab4d32c1d9be81ae96d6e24118c05d204d2c11bd0be26ca1160a18a06983e"
  license "MIT"
  head "https://github.com/Azure/aks-mcp.git", branch: "main"

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/Azure/aks-mcp/internal/version.GitVersion=#{version}
      -X github.com/Azure/aks-mcp/internal/version.GitCommit=#{tap.user}
      -X github.com/Azure/aks-mcp/internal/version.GitTreeState=clean
      -X github.com/Azure/aks-mcp/internal/version.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/aks-mcp"
  end
end
