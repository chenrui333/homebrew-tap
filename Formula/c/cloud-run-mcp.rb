class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.11.0.tgz"
  sha256 "0f5ee1e7bb57c136a1164ce1008da9795946af76c76eb3a54e58ea4cb7383186"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f371113d7fd3559fa40ae0ece19e3df4bf572559e0098ac98b5bcbcbfe730e4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f371113d7fd3559fa40ae0ece19e3df4bf572559e0098ac98b5bcbcbfe730e4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb8270e0a25d78ca96afcaa603d876cb8eeececc20a18bc2f31ead471a5548cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb8270e0a25d78ca96afcaa603d876cb8eeececc20a18bc2f31ead471a5548cf"
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
    modules.glob("{bare-fs,bare-os,bare-path,bare-url}/prebuilds").each(&:rmtree)

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
