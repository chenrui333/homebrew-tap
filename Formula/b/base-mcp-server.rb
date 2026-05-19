class BaseMcpServer < Formula
  desc "MCP Server for Base Network and Coinbase API"
  homepage "https://github.com/base/base-mcp"
  url "https://registry.npmjs.org/base-mcp/-/base-mcp-1.0.14.tgz"
  sha256 "efa952069cb0f1ceb834f2bdde2d54c2f1e0f099b3c4ba7e83d54b6bd84e0b50"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "34e5f91ae29f10578778b473ea5e4f1531a165f35bbaff6430093820550ce7f2"
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
    pkg = libexec/"lib/node_modules/base-mcp/package.json"
    assert_match version.to_s, pkg.read
    assert_path_exists bin/"base-mcp-server"
  end
end
