class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.8.0.tgz"
  sha256 "113ac56e85353dee391533fa8a4cfeb221e9ef92e13c77794abca1c19e3acdd8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "a9288cf2a586928814161fa9bba2fc2f4a5f1bd8cecc50888ce7af4345930638"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
