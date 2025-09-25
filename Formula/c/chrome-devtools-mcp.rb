class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.3.0.tgz"
  sha256 "87bdfda63cb224c67871a95bef3d774afb561d8b46fc3cc1d57d403813352bb8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "64ba30aa12f13eb6f58deda28cc2af130091187fac3ad04387cfeb6c0675616d"
    sha256 cellar: :any,                 arm64_sonoma:  "8879ac4c6461da3c880e50cc186d8d21499745aa706dc6ad83e7c4f122ccf83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f51162bd7004369524f5af09a753e1b7042520a6d30dd421f9f7b6945a78706b"
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
