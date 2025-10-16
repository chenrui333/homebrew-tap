class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.32.tgz"
  sha256 "6d09ea7b9b62d8cdcd648bac253a379602fef67acdb0a76ab0670c0ea33a36e7"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "cd391c43c5e92bb6c017c867e4ac28ede63e6d541b25929dcca9053d1d1d982b"
    sha256 cellar: :any,                 arm64_sequoia: "1bbea151b472c6fbe6076d171eb86af455c4e2ae3e16aa6f1385fd0e0e84d5e9"
    sha256 cellar: :any,                 arm64_sonoma:  "1bbea151b472c6fbe6076d171eb86af455c4e2ae3e16aa6f1385fd0e0e84d5e9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5db99d5cf0eb7ce4484b2feb5a3167d9fe36ec022c7e77372c24b2e0d098ca97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b4288c953ae9dd3487bb72a866107e394e2bbc23a99e1aba6dd25957a1834609"
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
