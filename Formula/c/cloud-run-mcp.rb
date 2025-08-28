class CloudRunMcp < Formula
  desc "MCP server to deploy code to Google Cloud Run"
  homepage "https://github.com/googlecloudplatform/cloud-run-mcp"
  url "https://registry.npmjs.org/@google-cloud/cloud-run-mcp/-/cloud-run-mcp-1.3.0.tgz"
  sha256 "17fe9083eedcfc3f6d18a36665b51b48b50072ef7e6da2f4fc6744aade2d8177"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b2980da58a92e35978b35557e4de86df8ed25da13c7aaa4bdbf63daebdd74bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1fa4e91ad5a6baf8125857b6836859a8253e78a80d729ab26710e523c2503cfb"
    sha256 cellar: :any_skip_relocation, ventura:       "f274bed55230201702cfe181b0a147e76edcd530ea346dd9ecac25729f5ee306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "30564cb70a53d4c882b9300c81fc8a35d0dd1c53bb161790de9f6e4de472ed3b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["GOOGLE_APPLICATION_CREDENTIALS"] = testpath/"credentials.json"
    (testpath/"credentials.json").write ""

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/cloud-run-mcp 2>&1", json, 0)
    assert_match "Lists Cloud Run services in a given project and region", output
  end
end
