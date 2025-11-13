class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.44.tgz"
  sha256 "db42b7c13fc0593a1048566f6446a3c042b5d406b1e0f9163463d1d7e0fb3254"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1affefac76ad02d6cac8067b9795b265ed40bdb99a277399c4d94feb324f2229"
    sha256 cellar: :any,                 arm64_sequoia: "5d1fe53097b1b05edcb6efa7a74b92bcea1926b57611a395a21ce63f0efb5555"
    sha256 cellar: :any,                 arm64_sonoma:  "5d1fe53097b1b05edcb6efa7a74b92bcea1926b57611a395a21ce63f0efb5555"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda4bd9734b3b22c2e6a9b5281e373f8a00e8d310bf3535f48494baa8f9a0c48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8445f96e14231755ccac1bd9cc387817a0c49ace9f2a0ac1b9718bbd8bdba379"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
