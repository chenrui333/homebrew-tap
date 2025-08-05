class BaseMcp < Formula
  desc "MCP Server for Base Network and Coinbase API"
  homepage "https://github.com/base/base-mcp"
  url "https://registry.npmjs.org/base-mcp/-/base-mcp-1.0.13.tgz"
  sha256 "c99de6839f782ed003569009c342bdd7962240669d276ae7e19ca12733472cf8"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_sequoia: "b870c314b829b8dd71318f77d613d8f3e2d078216f3637b78b01a5b7be2461bc"
    sha256                               arm64_sonoma:  "e2e7d2b5cdac4afb3b188011a0c4020ba505d43be449843383ea5498fde3fa7d"
    sha256                               ventura:       "b909f1df2ee3ebe14f6f2fa6bef3487eaf2cf5d0cb61015298b9c8a90d62e079"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15ead89abc086ddea4a98ccf51ad1ff7f76d8ca2fd78e51173a5e1744fba4c92"
  end

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
