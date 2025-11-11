class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.43.tgz"
  sha256 "965010399f916545444c633b0268fa84cac7de1af39ff2b8367b4ae91955176b"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "d374ec0495580fd29f011ae2f6d5b726aff3cd2b40562ed611dddbc6f4566cd2"
    sha256 cellar: :any,                 arm64_sequoia: "6dc2d93a65a9f1cad48af840103259dbb2bc87d98c2f73822a3b5ea70ae2c440"
    sha256 cellar: :any,                 arm64_sonoma:  "6dc2d93a65a9f1cad48af840103259dbb2bc87d98c2f73822a3b5ea70ae2c440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afc8b51482b096cd0b2b0a9b80fcfb968472b3c3896409d67713a6d53e476099"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d72ab5aef31f4d2ae23eb7d3f9256fdf35dacb865dba61e5c7a648069cf431d7"
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
