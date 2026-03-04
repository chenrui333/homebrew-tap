class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.10.0.tgz"
  sha256 "eb189a42f04949c49c379379873740be85d94d06a5e2190e31ef2691968a2048"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "02107236be3f77fdf174c387f310a54b3ed0bb71327149da59b1622d5d6cac25"
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
