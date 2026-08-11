class AksMcp < Formula
  desc "MCP server for Azure Kubernetes Service (AKS)"
  homepage "https://github.com/Azure/aks-mcp"
  url "https://github.com/Azure/aks-mcp/archive/refs/tags/v0.0.20.tar.gz"
  sha256 "80b5ba895cb70c2fa71e6f1f10da81c887943d3cddedcd0b2e6ecc05752db34d"
  license "MIT"
  head "https://github.com/Azure/aks-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "462f95e0afd01e8e34833835a5748cc9a7ff5170f5604f3750ca8049e6063943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "462f95e0afd01e8e34833835a5748cc9a7ff5170f5604f3750ca8049e6063943"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "462f95e0afd01e8e34833835a5748cc9a7ff5170f5604f3750ca8049e6063943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5840ff85abb4ff32d7bf2d42e2f167c25b28e2b7f6f9d067e2e621ac942f50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73408f281794e0deac059f8c33a9da162ed0fc3f2d907eaaec16b8f44333792a"
  end

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

    system "go", "build", "-tags=withoutebpf", *std_go_args(ldflags:), "./cmd/aks-mcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aks-mcp --version")

    output = shell_output("#{bin}/aks-mcp --enabled-components=nope 2>&1", 1)
    assert_match "invalid components: nope", output
  end
end
