class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.8.0.tgz"
  sha256 "113ac56e85353dee391533fa8a4cfeb221e9ef92e13c77794abca1c19e3acdd8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33b5aef4756c5f222f97ebc73ffc54ef32c0eef87fc2e028c538ed13b6014c23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1f6347052e8421908243b90dcbb23a1cf045972f678b3f768a864eafc00b542"
    sha256 cellar: :any_skip_relocation, ventura:       "c3a050a829c7c1b8e9411fdaefe56ae541943552476f5faee353aa439604e684"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "221b89c1a3190a2ce6ed7396d7f7e0fe4f2c79f552f0481d3a59996f8c3c4a67"
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
