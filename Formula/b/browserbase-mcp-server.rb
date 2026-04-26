class BrowserbaseMcpServer < Formula
  desc "MCP server for AI web browser automation using Browserbase and Stagehand"
  homepage "https://github.com/browserbase/mcp-server-browserbase"
  url "https://registry.npmjs.org/@browserbasehq/mcp-server-browserbase/-/mcp-server-browserbase-2.4.3.tgz"
  sha256 "d0255d41e987f916797eda5c209de4b219090f83e0dd01a713b6bd398d81ad81"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256                               arm64_tahoe:   "0321a4628679b5f98129902355e6676714eec366011ea309a8181b9500acbdcd"
    sha256                               arm64_sequoia: "4e96bd67d30ac416a080c3851254c30ba8b1cc0e949ea32ddc6392033ec6ad04"
    sha256                               arm64_sonoma:  "4e96bd67d30ac416a080c3851254c30ba8b1cc0e949ea32ddc6392033ec6ad04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4e282eefa3fe6e366887e808cc00cae955fbcdb2ac0d611256d5e6c748649c1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72019e5ecabc5ab7c3b5b2678747bbfa1787c97a3cdc94a02d97f47e92232909"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/mcp-server-browserbase" => "browserbase-mcp-server"

    # Remove incompatible pre-built native artifacts and keep only the host one.
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    libexec.glob("lib/node_modules/**/{bare-fs,bare-os,bare-url,bufferutil}/prebuilds/*")
           .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
    libexec.glob("lib/node_modules/**/@rollup/rollup-*").each(&:rmtree)

    if OS.linux?
      # Keep glibc artifacts and prune vendored musl binaries that fail linkage.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
      libexec.glob("lib/node_modules/**/@img/sharp-linuxmusl-*").each(&:rmtree)
      libexec.glob("lib/node_modules/**/@img/sharp-libvips-linuxmusl-*").each(&:rmtree)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/browserbase-mcp-server --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"browserbase-mcp-server", json, 0)
    assert_match "Create or reuse a Browserbase browser session and set it as active", output
  end
end
