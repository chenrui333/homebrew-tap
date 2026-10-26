class AksMcp < Formula
  desc "MCP server for Azure Kubernetes Service (AKS)"
  homepage "https://github.com/Azure/aks-mcp"
  url "https://github.com/Azure/aks-mcp/archive/refs/tags/v0.0.22.tar.gz"
  sha256 "9714e1b7c7927bc3daf7036a02afebff8044dff0229f5ebe53140f7f1077e876"
  license "MIT"
  head "https://github.com/Azure/aks-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "541c30dca0aa73cdf54b8d316f4329c6b6f2290f452ccb9d7f54902c412d1a00"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "541c30dca0aa73cdf54b8d316f4329c6b6f2290f452ccb9d7f54902c412d1a00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b24aafa906a5946060a0cdef10cd3c6f79d2bd414c7f6bb88cf3b2f8f52188b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ef0e9deef02294e26176c82e2c7b1b5d035b528ac4b77921a1fc868ea6a29bd"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
