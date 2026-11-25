class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.13.0.tgz"
  sha256 "f2f6123be18622d83338fa83937545bb334d226ede00368bc96eb4fe53b61f61"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "daccdcd441f52493b3c1d30fb04b16983953305ab3ccea6cabe6c76d557d9454"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32282ca4cd8f4bcf8746be7a0ed4691c5bbd40912cc2f1e8f0cbf002a871eb27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32282ca4cd8f4bcf8746be7a0ed4691c5bbd40912cc2f1e8f0cbf002a871eb27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abf91d09a96fded69db13d31aff211d96353f5c0eccc13ce18e29c52caf7013c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "abf91d09a96fded69db13d31aff211d96353f5c0eccc13ce18e29c52caf7013c"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: false)
  end

  def install
    system "npm", "install", "--offline", *std_npm_args

    # These optional native prebuilds vary by platform and break `:all` bottles.
    modules = libexec/"lib/node_modules/@google-cloud/cloud-run-mcp/node_modules"
    modules.glob("{bare-buffer,bare-fs,bare-os,bare-path,bare-url}/prebuilds").each(&:rmtree)

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = testpath/"credentials.json"
    (testpath/"credentials.json").write ""

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/cloud-run-mcp 2>&1", json, 0)
    assert_match "Lists all Cloud Run services in a given project.", output
  end
end
