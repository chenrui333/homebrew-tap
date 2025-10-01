class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.6.0.tgz"
  sha256 "6a3bf7b741efc718fe2e6b75ba97b9b0d7885b957bd4bae2c2dbcb7cd1aa6ddb"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "f83ee9fccdc61aa680480f0506da1ff87a7838a56f483a469a05cdb31ad47148"
    sha256 cellar: :any,                 arm64_sonoma:  "78a32299557bbd099ae2ff7cfaa5d92be0eadc79a0bc31e34de66433dd3dde33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0f51cc7c2a926227969ce06fb1e9367631d1b2cd0fb1b746abd219c15c2d6d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/chrome-devtools-mcp/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chrome-devtools-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"chrome-devtools-mcp", json, 0)
    assert_match "The CPU throttling rate representing the slowdown factor 1-20x", output
  end
end
