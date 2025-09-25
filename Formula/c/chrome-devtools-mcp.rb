class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.3.0.tgz"
  sha256 "87bdfda63cb224c67871a95bef3d774afb561d8b46fc3cc1d57d403813352bb8"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_sequoia: "d1ad7833b5f4670102e5c9d17b8f91032ad4adcd6a613977018b0ec504e08617"
    sha256 cellar: :any,                 arm64_sonoma:  "548b6467f704d403aa7d7011e3dd61a913587c1f7ecf9c811133f6d98bf3aac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bab0a0b0f44524ee959afdf449c0b39427b6ea3910b5a3881980d9da2177ad7"
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
