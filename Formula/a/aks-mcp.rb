class AksMcp < Formula
  desc "MCP server for Azure Kubernetes Service (AKS)"
  homepage "https://github.com/Azure/aks-mcp"
  url "https://github.com/Azure/aks-mcp/archive/refs/tags/v0.0.19.tar.gz"
  sha256 "5fc1ba7497cd6985a9146a85b1bd38e3bfd431518587debf3211e5d80e300928"
  license "MIT"
  head "https://github.com/Azure/aks-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0ca591c547cf455247aecb41d2dcd7ce1a572d20e43920af38a95b9140a1d11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0ca591c547cf455247aecb41d2dcd7ce1a572d20e43920af38a95b9140a1d11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f0ca591c547cf455247aecb41d2dcd7ce1a572d20e43920af38a95b9140a1d11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93a6215aba3878ede56d5fd4d9bd6bf543dee113c5e11dca2f11fa0d9970b934"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "625655dcf16e9cb6562240c8fa10370d5c6e88e18048b1f543194b8f0c702528"
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
