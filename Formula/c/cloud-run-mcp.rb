class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.13.0.tgz"
  sha256 "f2f6123be18622d83338fa83937545bb334d226ede00368bc96eb4fe53b61f61"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "062426c2ad5a26113aef7f22e6a3680d48d6f8b0bf204b7b99caa067b93b96f1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "062426c2ad5a26113aef7f22e6a3680d48d6f8b0bf204b7b99caa067b93b96f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3403e8e441ab07e333cd8f31a95dd29fca0fecb0c15f741818000351d9ba439a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3403e8e441ab07e333cd8f31a95dd29fca0fecb0c15f741818000351d9ba439a"
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
