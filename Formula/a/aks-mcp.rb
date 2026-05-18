class AksMcp < Formula
  desc "MCP server for Azure Kubernetes Service (AKS)"
  homepage "https://github.com/Azure/aks-mcp"
  url "https://github.com/Azure/aks-mcp/archive/refs/tags/v0.0.18.tar.gz"
  sha256 "74fa9a3fa7f273fb61e81eea6476fcff6bb3d079fb77e785903d282e0db6d33d"
  license "MIT"
  head "https://github.com/Azure/aks-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8696c08c830b014f6118cb0c547eea2d982f47ebd2c5c82fb06f299a37a01a53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8696c08c830b014f6118cb0c547eea2d982f47ebd2c5c82fb06f299a37a01a53"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8696c08c830b014f6118cb0c547eea2d982f47ebd2c5c82fb06f299a37a01a53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "460f132cf9a87ba3c7e29fc43f540fe217207269789ddd69253589d786a03910"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff7b2172a617f49b927d58cdba662c7ce8be451b57466cc3255b4bb680d1b59e"
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
