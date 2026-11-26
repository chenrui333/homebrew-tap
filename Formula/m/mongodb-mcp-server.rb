class MongodbMcpServer < Formula
  desc "MCP Server to connect to MongoDB databases and MongoDB Atlas Clusters"
  homepage "https://github.com/mongodb-js/mongodb-mcp-server"
  url "https://registry.npmjs.org/mongodb-mcp-server/-/mongodb-mcp-server-3.4.0.tgz"
  sha256 "55962cd955415513d5a7ed6d140fef1c7b45ac080deda2db10b1fac5623b23ac"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "92b0a1493e01d0f84ffb598c3e23ca34cf416f01279ff2095f2fc4bce4c7734b"
    sha256                               arm64_tahoe:   "cbca9c4cb40b6c905c78aa0f57669c4a606189c3825347172f2fb36f202a19b6"
    sha256                               arm64_sequoia: "cbca9c4cb40b6c905c78aa0f57669c4a606189c3825347172f2fb36f202a19b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fc7e058a13686ca6b45eda78254c4545069a00c623d529c0d52a8194119197d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06c4f20a84a31159bef9555d1b656c169b7d87a3b6738a0af130fe8f418b8401"
  end

  depends_on "node"

  deny_network_access!

  def fetch
    system "npm", "install", *std_npm_args(prefix: buildpath/"npm-fetch")
  end

  def install
    rm_r buildpath/"npm-fetch"
    system "npm", "install", "--offline", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    if OS.linux?
      # ext-apps vendors Bun platform packages; keep glibc builds but remove
      # musl variants to satisfy linkage checks on Homebrew Linux runners.
      libexec.glob("lib/node_modules/**/@oven/bun-linux-*-musl*").each(&:rmtree)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mongodb-mcp-server --version")

    output = shell_output("#{bin}/mongodb-mcp-server --httpPort 65536 2>&1", 1)
    assert_match "Invalid httpPort: must be at most 65535", output
  end
end
