class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.41.tgz"
  sha256 "334b72702fe7fa5004c05cc048a986119ba5ca9dca7a294cb0479fe609a56351"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "7b32e5984f4c5378596a3fcc11c22277ac42654a9e5a032eaf94341dfbe08661"
    sha256 cellar: :any,                 arm64_sequoia: "130cdbaed6f9937c4cd93490b954d95e6a62b15b0e82425c06f78041685a6dce"
    sha256 cellar: :any,                 arm64_sonoma:  "130cdbaed6f9937c4cd93490b954d95e6a62b15b0e82425c06f78041685a6dce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f81793f933350470d38ae6cbccb01d2b82ceaa052da6f9f5ac2e30ff26eb71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "971da4f897fd90af810ee5a8ff26dab6106e07b635638d544181ead5e690ddbf"
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
