class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.40.tgz"
  sha256 "49d051240728f402220428a0f08d00929dcdcda30a634aea5042dd37ba97df90"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any,                 arm64_tahoe:   "9483d5c5a96b7315d46826070ccc077e1916640743b1562375fd859afb4e6a52"
    sha256 cellar: :any,                 arm64_sequoia: "7af28e443f85a07ad4d0c5adbf36d6f8e45e31fe6aceb3d4f174e29339426e26"
    sha256 cellar: :any,                 arm64_sonoma:  "7af28e443f85a07ad4d0c5adbf36d6f8e45e31fe6aceb3d4f174e29339426e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5143a3a10ad2cfd21deb7648fa69a8072d75c2254343ef0d82cb9a7784b4605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22ed8acc01dc2105d031c37d2563d86c725fd9b8dd82fe7ecc6b8495f6910053"
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
