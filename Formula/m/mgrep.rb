class Mgrep < Formula
  desc "CLI-native semantic grep for code, images, PDFs, and more"
  homepage "https://github.com/mixedbread-ai/mgrep"
  url "https://registry.npmjs.org/@mixedbread/mgrep/-/mgrep-0.1.8.tgz"
  sha256 "d2df025f6accd6c3e5a91849ee2c29ef006e7a9d9ee17ae09325ba79573d9218"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mgrep --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output("#{bin}/mgrep mcp 2>&1", json, 0)
    assert_match "[LOG] [SYNC] Starting file sync", output
  end
end
