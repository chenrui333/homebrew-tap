class AksMcp < Formula
  desc "MCP server for Azure Kubernetes Service (AKS)"
  homepage "https://github.com/Azure/aks-mcp"
  url "https://github.com/Azure/aks-mcp/archive/refs/tags/v0.0.17.tar.gz"
  sha256 "b29a1b9071c4cd9ce2c5fa748e2f6beec2580e829808e776c381da57f89fe375"
  license "MIT"
  head "https://github.com/Azure/aks-mcp.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2926b1298c67e8f9a9c284142a93711532b83e13348babcaa257c05ebcc2b8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2926b1298c67e8f9a9c284142a93711532b83e13348babcaa257c05ebcc2b8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c2926b1298c67e8f9a9c284142a93711532b83e13348babcaa257c05ebcc2b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5e599b10e3ff3d0b38a3659a25ee303f95543bfbf21076519d6788bd8e70e82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7efa983b6f9de3bff1d165e7e72e67ee9b691bdb81e0cc2e86f09f0d1ad0c67c"
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
