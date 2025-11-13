class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.45.tgz"
  sha256 "683a6d057c1c3342498585d27b4498e117dd008980e8d0e15fdca356b5eebd92"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "0eac2eab53de5f4d199a65fcfe91d35a907f9fcfda902303a6367009aca8367a"
    sha256 cellar: :any,                 arm64_sequoia: "dd1102ce6ef34c1727bf0c2834eca35bdddde6d4c42b0ab44086940d705535e7"
    sha256 cellar: :any,                 arm64_sonoma:  "dd1102ce6ef34c1727bf0c2834eca35bdddde6d4c42b0ab44086940d705535e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10bd6512845862a321d417be6bf4d6d4ae56ddcdc23e00dd40031f3210ad12b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb8c209c27c085868d0e7b98742657d8c304d902bd024531c3d813288a412e0a"
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
