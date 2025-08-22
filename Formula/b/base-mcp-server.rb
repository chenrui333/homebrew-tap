class BaseMcpServer < Formula
  desc "MCP Server for Base Network and Coinbase API"
  homepage "https://github.com/base/base-mcp"
  url "https://registry.npmjs.org/base-mcp/-/base-mcp-1.0.13.tgz"
  sha256 "c99de6839f782ed003569009c342bdd7962240669d276ae7e19ca12733472cf8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "f6a139930d9ff8da77e6d4e444e73b19e243155a6cdb5e9fc241ba70ffc6e2ff"
    sha256                               arm64_sonoma:  "ce2fd4bbd72fb802e491f97f914799b366527b39479273c14cc196e020b0d5cc"
    sha256                               ventura:       "59a8ebc94fb90dc794ce00634596a9424c4c43dacbaee1c4f60da02a922ae1e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a190a8a6e38c0877381eeec67d86127df517d4b2047f1a3dd1f58cf607dd0b66"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/base-mcp" => "base-mcp-server"

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
    assert_match version.to_s, shell_output("#{bin}/base-mcp-server --version")

    ENV["COINBASE_API_KEY_NAME"] = "test"
    ENV["COINBASE_API_PRIVATE_KEY"] = "test"

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    assert_match "Error: Failed to initialize wallet", pipe_output("#{bin}/base-mcp-server 2>&1", json, 1)
  end
end
