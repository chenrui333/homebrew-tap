class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.30.tgz"
  sha256 "1a090fb8561337aef3c6a012d0085bd1f51f85a3bc76762a2e2aa1c59bc48c64"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "1a2ea5cc3d97f8157bac2bd22aa7185467937fbfa6f69a07a351fb77092c4220"
    sha256 cellar: :any,                 arm64_sequoia: "ba3b3e8f384d885c04f6e19d6df4624cf622fa76b0ce806b9fc67b15fc039eba"
    sha256 cellar: :any,                 arm64_sonoma:  "bcf11bcfa52def122e9f1f11ad7f2d56c654869eceba33649290c29126ecea31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9782daff3e7ca85f9e7478887eedecc21fcf6c7953dfdf2ac71b3e06589735ae"
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
    assert_match "STDIO transport initialized", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
