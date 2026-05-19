class BaseMcpServer < Formula
  desc "MCP Server for Base Network and Coinbase API"
  homepage "https://github.com/base/base-mcp"
  url "https://registry.npmjs.org/base-mcp/-/base-mcp-1.0.14.tgz"
  sha256 "efa952069cb0f1ceb834f2bdde2d54c2f1e0f099b3c4ba7e83d54b6bd84e0b50"
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
    pkg = libexec/"lib/node_modules/base-mcp/package.json"
    assert_match version.to_s, pkg.read
    assert_path_exists bin/"base-mcp-server"
  end
end
