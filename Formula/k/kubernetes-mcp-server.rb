class KubernetesMcpServer < Formula
  desc "MCP server for Kubernetes"
  homepage "https://github.com/containers/kubernetes-mcp-server"
  url "https://github.com/containers/kubernetes-mcp-server/archive/refs/tags/v0.0.49.tar.gz"
  sha256 "2adeaf5f602388ff1f35c3e5a4c49324d58b524c9d9c0c3269870b73d3e02e36"
  license "Apache-2.0"
  head "https://github.com/containers/kubernetes-mcp-server.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "285fd5dc59c6ca93755ccd0dc2fe63d5e20310ae1142b64298a130078c63a24d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e2bac0664ed78823b85f53ebf38bb2f49415e2561076ff8813ee7470fba4e97"
    sha256 cellar: :any_skip_relocation, ventura:       "753fde226eeb0942274e3a561be6b7d5c0e4d0a74ec3a191cd716cfe2626a79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25c47956ba24baf2760880608955823f6f0b561f6c2a6816c1f9c4d3164b29d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/containers/kubernetes-mcp-server/pkg/version.CommitHash=#{tap.user}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.BuildTime=#{time.iso8601}
      -X github.com/containers/kubernetes-mcp-server/pkg/version.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/kubernetes-mcp-server"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubernetes-mcp-server --version")

    kubeconfig = testpath/"kubeconfig"
    kubeconfig.write <<~YAML
      apiVersion: v1
      kind: Config
      clusters:
      - cluster:
          server: https://localhost:6443
          insecure-skip-tls-verify: true
        name: test-cluster
      contexts:
      - context:
          cluster: test-cluster
          user: test-user
        name: test-context
      current-context: test-context
      users:
      - name: test-user
        user:
          token: test-token
    YAML

    ENV["KUBECONFIG"] = kubeconfig.to_s

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"kubernetes-mcp-server", json, 0)
    assert_match "Get the current Kubernetes configuration content as a kubeconfig YAML", output
  end
end
