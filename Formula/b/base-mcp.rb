class BaseMcp < Formula
  desc "MCP Server for Base Network and Coinbase API"
  homepage "https://github.com/base/base-mcp"
  url "https://registry.npmjs.org/base-mcp/-/base-mcp-1.0.13.tgz"
  sha256 "c99de6839f782ed003569009c342bdd7962240669d276ae7e19ca12733472cf8"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible pre-built binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/base-mcp/node_modules"
    node_modules.glob("{keccak,secp256k1}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    if OS.linux?
      (node_modules/"keccak/prebuilds/linux-x64").glob("*.musl.node").map(&:unlink)
      (node_modules/"secp256k1/prebuilds/linux-x64").glob("*.musl.node").map(&:unlink)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/base-mcp --version")

    ENV["COINBASE_API_KEY_NAME"] = "test"
    ENV["COINBASE_API_PRIVATE_KEY"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Error: Failed to initialize wallet", pipe_output("#{bin}/base-mcp 2>&1", json, 1)
  end
end
