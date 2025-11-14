class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.46.tgz"
  sha256 "68547c57b323218f923eba9f1ad17ed8f8ce4bdfad5059c17ff5f9416846d8a6"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "068f7b8ee52ca13863dde611af992e5feef70735d2f1fb835751a24ed457fb18"
    sha256 cellar: :any,                 arm64_sequoia: "66fa954336f5f39765ec7895683423d61660dbadbf95cfbdea7aebcb5fed5477"
    sha256 cellar: :any,                 arm64_sonoma:  "66fa954336f5f39765ec7895683423d61660dbadbf95cfbdea7aebcb5fed5477"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da91e6ebd07fc9413e99adb06006456687cfd965f790f638f0954c8898ec821"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a55abfb879d642f2624f6c58b26c32dc65edf4ead8874632dc8e4f321c9e7c8e"
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
